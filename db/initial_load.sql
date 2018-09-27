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
TODO: replcate insert with COPY command and read from csv
--------------------------------------------*/
delete from public.transaction_category; 


insert into public.transaction_category
(
    transaction_category,
    transaction_category_group,
    display_order
)
    values
    ('Unknown', 'Unknown', 9999),
    ('Salary', 'Income', 1),
    ('Rental income', 'Income', 2),
    ('Bonuses / overtime', 'Income', 3),
    ('Income from savings and investments', 'Income', 4),
    ('Medicare benefits', 'Income', 5),
    ('Centrelink benefits', 'Income', 6),
    ('Family benefit payments', 'Income', 7),
    ('Tax', 'Tax', 8),
    ('Land tax', 'Tax', 9),
    ('Mortgage & rent', 'Home & utilities', 10),
    ('Body corporate fees', 'Home & utilities', 11),
    ('Council rates', 'Home & utilities', 12),
    ('Furniture & appliances', 'Home & utilities', 13),
    ('Renovations & maintenance', 'Home & utilities', 14),
    ('Electricity', 'Home & utilities', 15),
    ('Gas', 'Home & utilities', 16),
    ('Water', 'Home & utilities', 17),
    ('Internet', 'Home & utilities', 18),
    ('Pay TV', 'Home & utilities', 19),
    ('Home phone', 'Home & utilities', 20),
    ('Mobile', 'Home & utilities', 21),
    ('Bank fees', 'Insurance & financial', 22),
    ('Car insurance', 'Insurance & financial', 23),
    ('Home & contents insurance', 'Insurance & financial', 24),
    ('Personal & life insurance', 'Insurance & financial', 25),
    ('Health insurance', 'Insurance & financial', 26),
    ('Car loan', 'Insurance & financial', 27),
    ('Credit card interest', 'Insurance & financial', 28),
    ('Investments & super contributions', 'Insurance & financial', 29),
    ('Charity donations', 'Insurance & financial', 30),
    ('Supermarket', 'Groceries', 31),
    ('Butcher', 'Groceries', 32),
    ('Fruit & veg market', 'Groceries', 33),
    ('Fish shop', 'Groceries', 34),
    ('Deli & bakery', 'Groceries', 35),
    ('Pet food', 'Groceries', 36),
    ('Cosmetics & toiletries', 'Personal & medical', 37),
    ('Hair & beauty', 'Personal & medical', 38),
    ('Medicines & pharmacy', 'Personal & medical', 39),
    ('Glasses & eye care', 'Personal & medical', 40),
    ('Dental', 'Personal & medical', 41),
    ('Doctors & medical', 'Personal & medical', 42),
    ('Hobbies', 'Personal & medical', 43),
    ('Clothing & shoes', 'Personal & medical', 44),
    ('Jewellery & accessories', 'Personal & medical', 45),
    ('Computers & gadgets', 'Personal & medical', 46),
    ('Sports & gym', 'Personal & medical', 47),
    ('Pet care & vet', 'Personal & medical', 49),
    ('Education', 'Personal & medical', 48),
    ('Professional', 'Personal & medical', 50),
    ('Dry cleaning', 'Personal & medical', 51),
    ('Coffee & tea', 'Entertainment & eat-out', 52),
    ('Lunches bought', 'Entertainment & eat-out', 53),
    ('Take-away & snacks', 'Entertainment & eat-out', 54),
    ('Drinks & alcohol', 'Entertainment & eat-out', 55),
    ('Bars & clubs', 'Entertainment & eat-out', 56),
    ('Restaurants', 'Entertainment & eat-out', 57),
    ('Books', 'Entertainment & eat-out', 58),
    ('Newspapers & magazines', 'Entertainment & eat-out', 59),
    ('Movies & music', 'Entertainment & eat-out', 60),
    ('Holidays', 'Entertainment & eat-out', 61),
    ('Celebrations & gifts', 'Entertainment & eat-out', 62),
    ('Other entertainment', 'Entertainment & eat-out', 63),
    ('Bus & train & ferry', 'Transport & auto', 64),
    ('Petrol', 'Transport & auto', 65),
    ('Road tolls & parking', 'Transport & auto', 66),
    ('Rego & licence', 'Transport & auto', 67),
    ('Repairs & maintenance', 'Transport & auto', 68),
    ('Fines', 'Transport & auto', 69),
    ('Airfares', 'Transport & auto', 70),
    ('Passport', 'Transport & auto', 71),
    ('Toys', 'Children', 72),
    ('Childcare', 'Children', 73),
    ('Sports & activities', 'Children', 74),
    ('School fees', 'Children', 75),
    ('Other school needs', 'Children', 76),
    ('Bank transfer', 'Exclude', 77),
    ('Bank payment', 'Exclude', 78),
    ('ATM withdrawal', 'Exclude', 79)
;
