import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewRouteMap } from './new-route-map';

describe('NewRouteMap', () => {
  let component: NewRouteMap;
  let fixture: ComponentFixture<NewRouteMap>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewRouteMap],
    }).compileComponents();

    fixture = TestBed.createComponent(NewRouteMap);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
