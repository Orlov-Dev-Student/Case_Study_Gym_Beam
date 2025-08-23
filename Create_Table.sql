--Task 1
create table customers(
	customer_id int generated always as identity primary key,
	name varchar(50) not null,
	email varchar(255) not null unique,
	address varchar(255) not null,
	registration_date date not null,
	region varchar(50) not null
);

create table category(
	category_id int generated always as identity primary key,
	category_name varchar(100) not null,
	parent_category_id int, 
	constraint fk_parent_category foreign key (parent_category_id)
    references category(category_id)
);

create table product(
	product_id int generated always as identity primary key,
	product_name varchar(100) not null,
	price decimal(8,2) not null check (price >= 0),
	description varchar(255) not null,
	available boolean not null,
	category_id int not null, 
	constraint fk_product_category foreign key (category_id)
    references category(category_id)
);


create table order_item(
	order_item_id int generated always as identity primary key,
	quantity int not null,
	unit_price decimal(8,2) not null check (unit_price >= 0),
	product_id int not null, 
	constraint fk_order_item_product foreign key (product_id)
    references product(product_id)
);

create table orders(
	order_id int generated always as identity primary key,
	order_date timestamp not null default now(),
	order_status varchar(50) not null,
	customer_id int not null, 
	order_item_id int not null, 
	constraint fk_ordrers_customer foreign key (customer_id)
    references customers(customer_id), 
	constraint fk_ordrers_order_item foreign key (order_item_id)
    references order_item(order_item_id)
);

create table order_transaction(
	transaction_id int generated always as identity primary key,
	transaction_date timestamp not null default now(),
	payment_method varchar(50) not null,
	total decimal(8,2) not null check (total >= 0),
	order_id not null, 
	constraint fk_ordrer_transaction foreign key (order_id)
    references orders(order_id)
);



--Task 2
--geo
create table country_dim (
    country_id  int generated always as identity primary key,
    country     varchar(100) not null
);

create table region_dim (
    region_id   int generated always as identity primary key,
    country_id  int not null,
    address     varchar(100),
    constraint fk_region_country foreign key (country_id)
    references country_dim(country_id)
);

--category info
create table subcategory_dim (
    subcategory_id   int generated always as identity primary key,
    subcategory_name varchar(100) not null
);

create table category_dim (
    category_id     int generated always as identity primary key,
    category_name   varchar(100) not null,
    subcategory_id  int,
    constraint fk_category_subcategory foreign key (subcategory_id)
    references subcategory_dim(subcategory_id)
);

--product info
create table product_dim (
    product_id    int generated always as identity primary key,
    product_name  varchar(100) not null
);

--sale time
create table year_dim (
    year_id    int generated always as identity primary key,
    sale_year  int not null
);

create table quarter_dim (
    quarter_id    int generated always as identity primary key,
    sale_quarter  int not null check (sale_quarter between 1 and 4)
);

create table month_dim (
    month_id    int generated always as identity primary key,
    sale_month  int not null check (sale_month between 1 and 12)
);

create table week_dim (
    week_id    int generated always as identity primary key,
    sale_week  int not null check (sale_week between 1 and 53)
);

create table time_dim (
    time_id    int generated always as identity primary key,
    sale_date  date not null unique,
    week_id    int not null,
    month_id   int not null,
    quarter_id int not null,
    year_id    int not null,
    constraint fk_time_week
        foreign key (week_id)    references week_dim(week_id),
    constraint fk_time_month
        foreign key (month_id)   references month_dim(month_id),
    constraint fk_time_quarter
        foreign key (quarter_id) references quarter_dim(quarter_id),
    constraint fk_time_year
        foreign key (year_id)    references year_dim(year_id)
);

--fact 
create table sales_fact (
    region_id   int not null,
    category_id int not null,
    time_id     int not null,
    product_id  int not null,
    quantity    int not null check (quantity > 0),
    unit_price  decimal(8,2) not null check (unit_price >= 0),

    constraint pk_sales_fact primary key (region_id, category_id, time_id, product_id),

    constraint fk_fact_region foreign key (region_id)
    references region_dim(region_id),
    constraint fk_fact_category foreign key (category_id) 
    references category_dim(category_id),
    constraint fk_fact_time foreign key (time_id)
    references time_dim(time_id),
    constraint fk_fact_product foreign key (product_id)  
    references product_dim(product_id)
);




