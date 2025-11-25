import { ComponentFixture, TestBed } from '@angular/core/testing';
import { PoolManagementComponent } from './pool-management';

describe('PoolManagementComponent', () => {
  let component: PoolManagementComponent;
  let fixture: ComponentFixture<PoolManagementComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PoolManagementComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PoolManagementComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
