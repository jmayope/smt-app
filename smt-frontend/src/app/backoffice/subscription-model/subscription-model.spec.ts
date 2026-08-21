import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SubscriptionModel } from './subscription-model';

describe('SubscriptionModel', () => {
  let component: SubscriptionModel;
  let fixture: ComponentFixture<SubscriptionModel>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SubscriptionModel]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SubscriptionModel);
    component = fixture.componentInstance;
    await fixture.whenStable();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
