import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewDriver } from './new-driver';

describe('NewDriver', () => {
  let component: NewDriver;
  let fixture: ComponentFixture<NewDriver>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewDriver],
    }).compileComponents();

    fixture = TestBed.createComponent(NewDriver);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
