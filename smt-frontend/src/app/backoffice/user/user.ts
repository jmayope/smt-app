import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Main } from '../../services/main';
import { Supabase } from '../../services/supabase';
import { firstValueFrom } from 'rxjs';
import { USERS } from '../../constants';

@Component({
  selector: 'app-user',
  imports: [
    CommonModule,
    FormsModule,
  ],
  templateUrl: './user.html',
  styleUrl: './user.css',
})
export class User implements OnInit {

  constructor(
    private Main: Main,
    private Supabase: Supabase,
    private ChangeDetector: ChangeDetectorRef
  ) {}

  users: any[] = [];

  ngOnInit(): void {
    this.getUsers();
  }

  async getUsers() {
    // let result_users: any = await firstValueFrom(this.Supabase.select(USERS, {filters: {}}));
    let result_users: any = await firstValueFrom(this.Supabase.select(USERS, {filters: {role: 'conductor'}}));
    this.users = result_users;
    console.log(this.users);
    this.ChangeDetector.detectChanges();
  }

}
