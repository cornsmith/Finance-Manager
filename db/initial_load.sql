/*--------------------------------------------
    calendar
--------------------------------------------*/
delete from public.calendar;

insert into public.calendar
(
    date
)
    select CURRENT_DATE + i 
	  from generate_series(date '2000-01-01'- CURRENT_DATE, date '2099-12-31' - CURRENT_DATE ) i
;

/*--------------------------------------------
    account_type
--------------------------------------------*/
delete from public.account_type;

insert into public.account_type
(
    account_type, 
    account_type_group
)
values
    ('Transaction', 'Debit'),
    ('Savings', 'Debit'),
    ('Term Deposit', 'Debit'),
    ('Credit Card', 'Credit'),
    ('Personal Loan', 'Credit'),
    ('Home Loan', 'Credit')
;

/*--------------------------------------------
    description
--------------------------------------------*/
delete from public.description;

insert into public.description
(
    description
)
values
    ('')
;

/*--------------------------------------------
    transaction_category
--------------------------------------------*/
delete from public.transaction_category; 

\copy public.transaction_category (transaction_category,income_expense_category,transaction_category_group,display_order) from './db/transaction_category.csv' with (FORMAT csv, HEADER)
