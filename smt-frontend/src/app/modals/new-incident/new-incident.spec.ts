import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewIncident } from './new-incident';

describe('NewIncident', () => {
  let component: NewIncident;
  let fixture: ComponentFixture<NewIncident>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewIncident],
    }).compileComponents();

    fixture = TestBed.createComponent(NewIncident);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
