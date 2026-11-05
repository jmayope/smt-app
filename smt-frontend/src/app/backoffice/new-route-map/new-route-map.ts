import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import * as L from 'leaflet';
import { loadingAlert, messageAlert, ROUTE_POINTS, ROUTE_SEGMENTS, ROUTES } from '../../constants';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import Swal from 'sweetalert2';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-new-route-map',
  imports: [
    CommonModule,
    FormsModule
  ],
  templateUrl: './new-route-map.html',
  styleUrl: './new-route-map.css',
})
export class NewRouteMap implements OnInit {

  constructor(
    private ActivatedRoute: ActivatedRoute,
    private Router: Router,
    private ChangeDetector: ChangeDetectorRef,
    private Main: Main,
    private Supabase: Supabase
  ) {
  }
  
  new_route: any = {};
  route_points: any[] = [];
  route_segments: any[] = [];

  route_id: string = "0";
  editing: boolean = false;
  map: any;
  currentCoords:[number, number] = [0,0];
  user_marker: L.Marker<any> | undefined;

  user_icon = L.icon({
    iconUrl: 'imgs/user_pin.png',
    iconSize: [35,41]
  });

  route_icon = L.icon({
    iconUrl: 'imgs/pin.png',
    iconSize: [35,35]
  })
  mapZoom: number = 15;
  click_markers: L.Marker<any>[] = [];
  markers_info: any[] = [];
  selected_marker: L.Marker<any> | null = null;
  user_loged: any;
  calculating: boolean = false;

  ngOnInit(): void {
    console.log(this.ActivatedRoute.snapshot.data);
    console.log(this.ActivatedRoute.snapshot.params);
    this.user_loged = this.Main.getSession();
    this.route_id = this.ActivatedRoute.snapshot.params["id"];
    console.log(this.route_id);
    if (this.route_id !== '0') {
      this.editing = true;
    }
    this.new_route.company_id = this.user_loged.currentCompany.id;
    
    this.initMap();
  }

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        let coords: [number, number] = [position.coords.latitude, position.coords.longitude];
        this.currentCoords = coords;
        if (this.user_marker) {
          this.user_marker.setLatLng(coords); 
        } else {
          this.user_marker = L.marker(coords, {
            icon: this.user_icon,
            draggable: true
          }).addTo(this.map).bindPopup("Estas aqui").openPopup();
        }

        this.user_marker.on("dragend", (event) => {
          let marker = event.target;
          let position = marker.getLatLng();
          marker.setLatLng(position).openPopup();
          this.map.setView(position, this.mapZoom);
          console.log(`Marker movido: posicion: ${position.lat} ${position.lng}`)
        });

        this.map.setView(coords, this.mapZoom);
        this.ChangeDetector.detectChanges();
      }, () => {
        messageAlert("Aviso", "No se pudo obtener la Geolocalización", "warning");  
      })
    } else {
      messageAlert("Aviso", "Geolocalización no soportada para este navegador", "warning");
    }
  }

  initMap() {
    this.map = L.map('map').setView(this.currentCoords, this.mapZoom);
    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(this.map);

    this.map.on("click", (event: L.LeafletMouseEvent) => {
      if ((event.originalEvent as MouseEvent).button !== 0) return; // solo click izquierdo
      this.addMarkerAt(event.latlng.lat, event.latlng.lng);
    });

    this.getLocation();
  }

  async addMarkerAt(lat: number, lng: number) {
    const newMarker = L.marker([lat, lng], {
      icon: this.route_icon,
      draggable: true
    })
      .addTo(this.map)
      .bindPopup(`Punto: ${lat.toFixed(2)}, ${lng.toFixed(2)}`);

    newMarker.on('click', (ev) => {
      L.DomEvent.stopPropagation(ev); // evita que el click del mapa agregue otro marker
      this.selectMarker(newMarker);
    });

    // (Opcional) permitir arrastrar el marker y actualizar el popup
    newMarker.on('dragend', (ev) => {
      const pos = (ev.target as L.Marker).getLatLng();
      newMarker.setPopupContent(`Punto: ${pos.lat.toFixed(5)}, ${pos.lng.toFixed(5)}`);
      this.getAdditionalData();
    });

    this.click_markers.push(newMarker);
    
    try {
      const response = await fetch(
        `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}&zoom=18&addressdetails=1`
      );
      const data = await response.json();
      
      // 3. Extraer el nombre de la calle (o una dirección formateada)
      const streetName = data.address?.road || data.display_name || "Dirección no encontrada";
      let route_point = {
        name: `punto ${lat} - ${lng}`,
        latitude: lat,
        longitude: lng,
        direction: `${streetName} - ${this.markers_info.length + 1}`,
        address: `${streetName} Lat: ${lat} - Lng:${lng}`
      };

      this.markers_info.push(route_point);
      this.getAdditionalData();
      this.ChangeDetector.detectChanges();
      // // 4. Actualizar el popup con el nombre
      // newMarker.setPopupContent(`<b>${streetName}</b><br>${lat.toFixed(5)}, ${lng.toFixed(5)}`);
      
    } catch (error) {
      console.error("Error en geocodificación inversa:", error);
      newMarker.setPopupContent(`Error al obtener dirección<br>${lat.toFixed(5)}, ${lng.toFixed(5)}`);
    }

  }

  async getAdditionalData() {
    loadingAlert("Calculando...");
    const { distance, duration, milestones } = await this.getRoadTotalEstimate();
    console.log(`Distancia: ${(distance / 1000).toFixed(2)} km`);
    console.log(milestones);
    this.markers_info.filter((i, k) => k > 0).map((i, k) => {
      let milestone_found = milestones[k];
      console.log(i);
      console.log(milestone_found);
      i.distance = milestone_found.distance;
      i.estimated_time_minutes = milestone_found.duration;
    });
    this.new_route.distance_km = parseFloat((distance / 1000).toFixed(2));
    this.new_route.estimated_duration_hours = parseFloat((duration / 3600).toFixed(2));
    console.log(this.markers_info);
    Swal.close();
    this.ChangeDetector.detectChanges();
  }

  selectMarker(marker: L.Marker<any>) {
    // Quitar selección anterior
    if (this.selected_marker) {
      this.selected_marker.getElement()?.classList.remove('marker-selected');
    }

    this.selected_marker = marker;

    // Resaltar el nuevo
    const el = marker.getElement();
    if (el) el.classList.add('marker-selected');

    this.ChangeDetector.detectChanges();
  }

  deselectMarker() {
    if (this.selected_marker) {
      this.selected_marker.getElement()?.classList.remove('marker-selected');
      this.selected_marker = null;
      this.ChangeDetector.detectChanges();
    }
  }

  deleteSelectedMarker() {
    if (!this.selected_marker) {
      messageAlert("Aviso", "No hay ningún punto seleccionado", "warning");
      return;
    }

    this.map.removeLayer(this.selected_marker);
    let index = this.click_markers.indexOf(this.selected_marker);
    this.click_markers = this.click_markers.filter(m => m !== this.selected_marker);
    this.markers_info = this.markers_info.filter((i, k) => k !== index);
    this.selected_marker = null;
    console.log(this.click_markers);
    console.log(this.markers_info);
    this.ChangeDetector.detectChanges();
  }

  getClickedCoords(): [number, number][] {
    return this.click_markers.map(m => {
      const ll = m.getLatLng();
      return [ll.lat, ll.lng];
    });
  }

  async getStraightDistance(): Promise<number> {
    if (this.click_markers.length < 2) return 0;

    const first = this.click_markers[0].getLatLng();
    const last = this.click_markers[this.click_markers.length - 1].getLatLng();

    // return first.distanceTo(last); // 👈 devuelve METROS

    // OSRM espera: lng,lat;lng,lat
    const url = `https://router.project-osrm.org/route/v1/driving/` +
      `${first.lng},${first.lat};${last.lng},${last.lat}?overview=false`;

    try {
      const res = await fetch(url);
      const data = await res.json();

      if (data.code !== 'Ok' || !data.routes?.length) {
        throw new Error('No se pudo calcular la ruta');
      }

      return data.routes[0].distance; // 👈 METROS por carretera
    } catch (err) {
      console.error('Error OSRM:', err);
      messageAlert("Aviso", "No se pudo calcular la distancia por carretera", "warning");
      return 0;
    }
  }

  async getRoadTotalEstimate(): Promise<{ distance: number; duration: number, milestones: any[] }> {
    if (this.click_markers.length < 2) return { distance: 0, duration: 0, milestones: [] };

    const coords = this.click_markers
      .map(m => {
        const ll = m.getLatLng();
        return `${ll.lng},${ll.lat}`;
      })
      .join(';');

    const url = `https://router.project-osrm.org/route/v1/driving/${coords}?overview=false`;

    try {
      const res = await fetch(url);
      const data = await res.json();
      if (data.code !== 'Ok' || !data.routes?.length) {
        throw new Error('No se pudo calcular la ruta');
      }
      const route = data.routes[0];
      return {
        distance: route.distance, // metros
        duration: route.duration,  // segundos,
        milestones: route.legs
      };
    } catch (err) {
      console.error('Error OSRM:', err);
      messageAlert("Aviso", "No se pudo calcular la estimación", "warning");
      return { distance: 0, duration: 0, milestones: [] };
    }
  }

  async getRoadTotalDistance(): Promise<number> {
    if (this.click_markers.length < 2) return 0;

    const coords = this.click_markers
      .map(m => {
        const ll = m.getLatLng();
        return `${ll.lng},${ll.lat}`;
      })
      .join(';');

    const url = `https://router.project-osrm.org/route/v1/driving/${coords}?overview=false`;

    try {
      const res = await fetch(url);
      const data = await res.json();
      if (data.code !== 'Ok' || !data.routes?.length) {
        throw new Error('No se pudo calcular la ruta');
      }
      return data.routes[0].distance;
    } catch (err) {
      console.error('Error OSRM:', err);
      return 0;
    }
  }

  async getRouteEstimate(): Promise<{ distance: number; duration: number }> {
    if (this.click_markers.length < 2) return { distance: 0, duration: 0 };

    const first = this.click_markers[0].getLatLng();
    const last = this.click_markers[this.click_markers.length - 1].getLatLng();

    const url = `https://router.project-osrm.org/route/v1/driving/` +
      `${first.lng},${first.lat};${last.lng},${last.lat}?overview=false`;

    try {
      const res = await fetch(url);
      const data = await res.json();

      if (data.code !== 'Ok' || !data.routes?.length) {
        throw new Error('No se pudo calcular la ruta');
      }

      const route = data.routes[0];
      return {
        distance: route.distance,  // metros
        duration: route.duration   // segundos
      };
    } catch (err) {
      console.error('Error OSRM:', err);
      messageAlert("Aviso", "No se pudo calcular la estimación", "warning");
      return { distance: 0, duration: 0 };
    }
  }

  goBack() {
    Swal.fire({
      text: `¿Estás seguro de salir de la ${this.editing ? 'edición' : 'creación'} de la Ruta?`,
      icon: 'question',
      showCancelButton: true, 
      showConfirmButton: true,
      allowEscapeKey: false,
      allowOutsideClick: false
    }).then((choice) => {
      if (choice.isConfirmed) {
        this.Router.navigate(["backoffice/administracion-de-ruta"]);
      }
    })
  }

  async saveChanges() {
    Swal.fire({
      text: '¿Estás seguro de guardar los cambios?',
      icon: 'question',
      showCancelButton: true, 
      showConfirmButton: true,
      allowEscapeKey: false,
      allowOutsideClick: false
    }).then(async (choice) => {
      if (choice.isConfirmed) {
        loadingAlert("Guardando información de la Ruta, Puntos y Segmentos");
        let new_route = structuredClone(this.new_route);
        new_route.start_location = this.markers_info[0].direction;
        new_route.end_location = this.markers_info[this.markers_info.length - 1].direction;
        console.log(new_route);
        let result_route: any = await firstValueFrom(this.Supabase.insert(ROUTES, new_route));
        if (!result_route.length) {
          messageAlert("Error", "Hubo un error al momento de crear la ruta", "error");
          return;
        }
        let route_created: any = result_route[0];

        for (let index = 0; index < this.markers_info.length; index++) {
          let marker = this.markers_info[index];
          
          let new_route_point: any = {
            route_id: route_created.id,
            point_code: `P${index}`,
            point_type: 'I',
            name: marker.direction,
            latitude: marker.latitude,
            longitude: marker.longitude,
            address: marker.address,
            sequence_order: index + 1,
            estimated_arrival_minutes: parseInt((marker.estimated_time_minutes || 0).toString())
          };

          let result_route_point: any = await firstValueFrom(this.Supabase.insert(ROUTE_POINTS, new_route_point));
          if (!result_route_point.length) {
            messageAlert("Error", "Hubo un error al momento de crear el punto en la ruta", "error");
            return;
          }
          marker.point = result_route_point[0];
        }

        for (let index = 0; index < this.markers_info.length; index++) {
          if (index < this.markers_info.length - 1) {
            let marker = this.markers_info[index];
            let next_marker = this.markers_info[index];
            let new_route_segment = {
              has_restriction: false,
              route_id: route_created.id,
              from_point_id: marker.point.id,
              to_point_id: next_marker.point.id,
              segment_order: index,
              distance_km: next_marker.distance - (marker.distance || 0),
              estimated_time_minutes: parseInt((next_marker.estimated_time_minutes - (marker.estimated_time_minutes || 0)).toString()),
            };

            let final_route_segment: any = await firstValueFrom(this.Supabase.insert(ROUTE_SEGMENTS, new_route_segment));
            if (!final_route_segment.length) {
              messageAlert("Error", "Hubo un error al momento de crear el segmento en la ruta", "error");
              return;
            }
          }
        }

        console.log(result_route);
        Swal.close();
        messageAlert("Éxito", "Se creó la ruta correctamente", "success");
        this.Router.navigate(["backoffice/administracion-de-ruta"]);

      }
    })
  }

}
