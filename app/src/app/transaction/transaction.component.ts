import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';

@Component({
  selector: 'app-transaction',
  templateUrl: './transaction.component.html',
  styleUrls: ['./transaction.component.css']
})
export class TransactionComponent implements OnInit {
  transactionForm: FormGroup;

  constructor() { }

  ngOnInit() {
    this.transactionForm = new FormGroup({
      creditAmount: new FormControl('', [Validators.required, this.maxCreditExceeded])
    });
  }

  submitTransaction() {
    if (this.transactionForm.valid) {
      // API call to submit transaction
    }
  }

  maxCreditExceeded(control: FormControl) {
    const dailyCreditLimit = 1000; // Assuming daily credit limit is 1000
    if (control.value > dailyCreditLimit) {
      return { 'maxCreditExceeded': true };
    }
    return null;
  }
}