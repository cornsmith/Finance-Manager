CREATE TABLE public.calendar
(
    date date NOT NULL,

    PRIMARY KEY (date)
);

CREATE TABLE public.account_type
(
    id serial NOT NULL,
    account_type text NOT NULL,
    account_type_group text NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE public.account
(
    id serial NOT NULL,
    account_number text NOT NULL,
    account_type_id integer NOT NULL,

    PRIMARY KEY (id),
    CONSTRAINT fk_account_type FOREIGN KEY (account_type_id)
        REFERENCES public.account_type (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE public.description
(
    id serial NOT NULL,
    description text NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE public.transaction_category
(
    id serial NOT NULL,
    transaction_category text NOT NULL,
    transaction_category_group text NOT NULL,
    income_expense_category text NOT NULL,
    display_order integer NOT NULL DEFAULT(0),

    PRIMARY KEY (id)
);

CREATE TABLE public.transaction
(
    id serial NOT NULL,
    account_id integer NOT NULL,
    description_id integer NOT NULL,
    date date NOT NULL, 
    amount numeric NOT NULL,
    transaction_category_id integer,
    
    PRIMARY KEY (id),
    CONSTRAINT fk_account_id FOREIGN KEY (account_id)
        REFERENCES public.account (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_description_id FOREIGN KEY (description_id)
        REFERENCES public.description (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_transaction_category_id FOREIGN KEY (transaction_category_id)
        REFERENCES public.transaction_category (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE public.description_transaction_category
(
    description_id integer NOT NULL,
    transaction_category_id integer NOT NULL,

    PRIMARY KEY (description_id),
    CONSTRAINT fk_description_id FOREIGN KEY (description_id)
        REFERENCES public.description (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_transaction_category_id FOREIGN KEY (transaction_category_id)
        REFERENCES public.transaction_category (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
