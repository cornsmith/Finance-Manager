CREATE OR REPLACE VIEW public.account_view AS
	select
		a1.account_number
		, a2.account_type
		, a2.account_type_group
	from
		public.account as a1
		inner join public.account_type as a2
			on a2.id = a1.account_type_id
;


CREATE OR REPLACE VIEW public.transaction_detail_view AS
	select
	  t1.id
		, a1.account_number
		, at1.account_type
		, at1.account_type_group
		, d1.description
		, t1.date
		, t1.amount
		, tc1.transaction_category
		, tc1.transaction_category_group
		, tc1.income_expense_category
		, tc1.display_order
		
	from 
		transaction AS t1 
		inner join account as a1
			on a1.id = t1.account_id
		inner join description as d1
			on d1.id = t1.description_id
		inner join account_type as at1
			on at1.id = a1.account_type_id
		left join description_transaction_category as dtc1
		  on dtc1.description_id = t1.description_id
		left join transaction_category as tc1
			on tc1.id = coalesce(t1.transaction_category_id, dtc1.transaction_category_id)
;


CREATE OR REPLACE VIEW public.total_position_view AS
	select
		a1.date
		, sum(a1.amount) over (order by a1.date rows unbounded preceding) as balance
	from (
		select
			c1.date
			, coalesce(sum(ptv1.amount), 0)	as amount
		from 
			calendar as c1
			left join public.transaction as ptv1
				on ptv1.date = c1.date
		where
			c1.date between (select min(date) from public.transaction) and current_date
		group by
			c1.date
	) as a1
;


CREATE OR REPLACE VIEW public.account_position_view AS
  select
  	a1.date
  	, a2.account_number
  	, sum(a1.amount) over (partition by a1.account_id order by a1.date rows unbounded preceding) as balance
  from (
  	select
  		c1.date
  		, a1.account_id
  		, coalesce(sum(ptv1.amount), 0)	as amount
  	from 
  		calendar as c1
  		cross join (
  			select
  				account_id
  				, min(date) as min_date
  				, max(date) as max_date
  			from
  				public.transaction
  			group by
  				account_id	
  		) as a1
  		left join public.transaction as ptv1
  			on ptv1.date = c1.date
  			and ptv1.account_id = a1.account_id
  	where
  		c1.date between a1.min_date and a1.max_date
  	group by
  		c1.date
  		, a1.account_id
  ) as a1
  inner join public.account as a2
  	on a2.id = a1.account_id
;