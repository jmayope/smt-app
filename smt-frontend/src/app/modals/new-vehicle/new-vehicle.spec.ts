import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewVehicle } from './new-vehicle';

describe('NewVehicle', () => {
  let component: NewVehicle;
  let fixture: ComponentFixture<NewVehicle>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewVehicle],
    }).compileComponents();

    fixture = TestBed.createComponent(NewVehicle);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
