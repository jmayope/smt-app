import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewRoute } from './new-route';

describe('NewRoute', () => {
  let component: NewRoute;
  let fixture: ComponentFixture<NewRoute>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewRoute],
    }).compileComponents();

    fixture = TestBed.createComponent(NewRoute);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
