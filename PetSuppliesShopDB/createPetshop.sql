create table customer (
customer_id int not null unique auto_increment primary key,
first_name varchar(45) not null,
last_name varchar(45) not null,
email_address varchar(45) not null,
constraint customer_chk_valid_email_suffix
check (email_address like '%@yahoo.com' or email_address like '%@gmail.com'),
phone_number varchar(13) not null,
constraint customer_chk_valid_phone_no_letters
check (phone_number between '0000000000000' and '0999999999999')
);

create table country (
id int not null unique auto_increment primary key,
country_name varchar(45),
constraint country_chk_valid_country_name_uppercase
check (country_name = upper(country_name)),
iso_code varchar(2),
constraint country_chk_valid_iso_code_uppercase
check (iso_code between 'AA' and 'ZZ' and iso_code = upper(iso_code))
);

create table delivery_address (
id  int not null unique auto_increment primary key,
country_id int not null,
constraint delivery_address_country_id_fk
foreign key(country_id) references country(id),
city nvarchar(45) not null,
street nvarchar(45) not null,
house_number int not null,
constraint delivery_address_chk_valid_house_nr_positive
check (house_number > 0)
);

create table customer_user (
customer_id int not null primary key, 
constraint customer_user_customer_id_fk
foreign key (customer_id) references customer(customer_id),
delivery_address_id int not null,
constraint customer_user_delivery_address_id_fk
foreign key(delivery_address_id) references delivery_address(id),
fidelity_reward_points int default 0,
constraint customer_user_chk_fidelity_points_nonzero
check (fidelity_reward_points >= 0),
newsletter_subscription boolean default false
);

create table log_in (
customer_id int not null primary key,
constraint log_in_customer_id_fk
foreign key (customer_id) references customer_user(customer_id),
username varchar(45) not null unique,
constraint log_in_chk_valid_username_length
check (length(username) > 8),
user_password varchar(45) not null,
constraint log_in_chk_valid_password
check (length(user_password) > 8)
);

create table c_payment_type (
id int not null unique auto_increment primary key,
payment_type varchar(45) not null unique
);

create table c_order_status (
id  int not null unique auto_increment primary key,
order_status varchar(45) not null unique
);

create table order_form (
order_id  int not null unique auto_increment primary key,
customer_id int not null,
constraint order_form_customer_id_fk
foreign key(customer_id) references customer(customer_id),
order_status_id int not null,
constraint order_form_order_staus_id_fk
foreign key(order_status_id) references c_order_status(id),
total real default 0,
constraint order_form_chk_total_positive
check (total>=0),
delivery_address_id int not null,
constraint order_form_delivery_address_id_fk
foreign key(delivery_address_id) references delivery_address(id),
order_date date not null,
payment_type_id int default 1,
constraint order_form_payment_type_id_fk
foreign key(payment_type_id) references c_payment_type(id)
);

create table c_product_availability (
id int not null unique auto_increment primary key,
availability varchar(45) not null unique
);

create table c_product_brand (
id int not null unique auto_increment primary key,
brand_name varchar(45) unique
);

create table product (
product_id int not null unique auto_increment primary key,
product_name varchar(45) not null,
price real not null,
constraint product_chk_price_positive
check (price > 0),
availability_id int not null,
constraint product_availability_id_fk
foreign key(availability_id) references c_product_availability(id),
brand_id int not null,
constraint product_brand_id_fk
foreign key(brand_id) references c_product_brand(id),
customer_rating int default 1
);


create table ordered_product (
order_id int not null,
constraint ordered_product_order_id_fk
foreign key(order_id) references order_form(order_id),
product_id int not null,
constraint ordered_product_product_id_fk
foreign key(product_id) references product(product_id),
product_quantity int default 1,
constraint ordered_product_chk_product_quantity_positive
check (product_quantity > 0),
constraint primary key(order_id,product_id)
);

create table c_special_diet (
id int not null unique auto_increment primary key,
special_diet varchar(45) not null unique
);

create table c_health_feature (
id int not null unique auto_increment primary key,
health_feature varchar(45) not null unique
);
create table c_lifestage (
id int not null unique auto_increment primary key,
lifestage varchar(45) not null unique
);
create table c_breed_size (
id int not null unique auto_increment primary key,
breed_size varchar(45) not null unique
);
create table c_body_weight (
id int not null unique auto_increment primary key,
min_weight real not null,
max_weight real not null
);

create table p_health (
product_id int not null primary key,
constraint p_health_product_id_fk
foreign key(product_id) references product(product_id),
lifestage_id int not null,
constraint p_health_lifestage_id_fk
foreign key(lifestage_id) references c_lifestage(id),
body_weight_id int not null,
constraint p_health_body_weight_id_fk
foreign key(body_weight_id) references c_body_weight(id),
special_diet_id int not null,
constraint p_health_special_diet_id_fk
foreign key(special_diet_id) references c_special_diet(id),
health_feature_id int not null,
constraint p_health_health_feature_fk
foreign key(health_feature_id) references c_health_feature(id),
);


create table c_food_flavour (
id int not null unique auto_increment primary key,
flavour varchar(45) not null unique
);

create table c_food_form (
id int not null unique auto_increment primary key,
food_form varchar(45) not null unique
);

create table c_food_type (
id int not null unique auto_increment primary key,
food_type varchar(45) not null unique
);

create table ph_food (
product_id int not null primary key,
constraint ph_food_product_id_fk
foreign key(product_id) references p_health(product_id),
food_flavour_id int not null,
constraint ph_food_food_flavour_id_fk
foreign key(food_flavour_id) references c_food_flavour(id),
food_form_id int not null,
constraint ph_food_food_form_id_fk
foreign key(food_form_id) references c_food_form(id),
food_type_id int not null,
constraint ph_food_food_type_id_fk
foreign key(food_type_id) references c_food_type(id),
quantity real not null,
constraint ph_food_chk_quantity_positive
check (quantity > 0)
);


create table c_active_ingredient (
id int not null unique auto_increment primary key,
active_ingredient varchar(45) not null unique
);

create table c_medication_form (
id int not null unique auto_increment primary key,
medication_form varchar(45) not null unique
);

create table c_medication_type (
id int not null unique auto_increment primary key,
medication_type varchar(45) not null unique
);

create table ph_healthcare (
product_id int not null primary key,
constraint ph_healthcare_product_id_fk
foreign key(product_id) references p_health(product_id),
active_ingredient_id int not null,
constraint ph_healthcare_active_ingredient_id_fk
foreign key(active_ingredient_id) references c_active_ingredient(id),
medication_form_id int not null,
constraint ph_healthcare_medication_form_id_fk
foreign key(medication_form_id) references c_medication_form(id),
medication_type_id int not null,
constraint ph_healthcare_medication_type_id_fk
foreign key(medication_type_id) references c_medication_type(id)
);

create table c_supply_feature (
id int not null unique auto_increment primary key,
supply_feature varchar(45) not null unique
);

create table c_supply_material (
id int not null unique auto_increment primary key,
supply_material varchar(45) not null unique
);

create table c_supply_colour (
id int not null unique auto_increment primary key,
supply_colour varchar(45) not null unique
);

create table p_supply (
product_id int not null primary key,
constraint p_supply_product_id_fk
foreign key(product_id) references product(product_id),
supply_feature_id int not null,
constraint p_supply_supply_feature_id_fk
foreign key(supply_feature_id) references c_supply_feature(id),
supply_material_id int not null,
constraint p_supply_supply_material_id_fk
foreign key(supply_material_id) references c_supply_material(id),
supply_colour_id int not null,
constraint p_supply_supply_colour_id_fk
foreign key(supply_colour_id) references c_supply_colour(id)
);

create table c_toy_type (
id int not null unique auto_increment primary key,
toy_type varchar(45) not null unique
);
create table c_toy_collection (
id int not null unique auto_increment primary key,
toy_collection varchar(45) not null unique
);

create table ps_toy (
product_id int not null primary key,
constraint ps_toy_product_id_fk
foreign key(product_id) references p_supply(product_id),
toy_type_id int not null,
constraint ps_toy_toy_type_id_fk
foreign key(toy_type_id) references c_toy_type(id),
lifestage_id int not null,
constraint ps_toy_lifestage_id_fk
foreign key(lifestage_id) references c_lifestage(id),
toy_collection_id int not null,
constraint ps_toy_toy_collection_id_fk
foreign key(toy_collection_id) references c_toy_collection(id)
);


create table c_leash_type (
id int not null unique auto_increment primary key,
leash_type varchar(45) not null unique
);

create table ps_leash (
product_id int not null primary key,
constraint ps_leash_product_id_fk
foreign key(product_id) references p_supply(product_id),
leash_type_id int not null,
constraint ps_leash_leash_type_id_fk
foreign key(leash_type_id) references c_leash_type(id),
leash_length real not null,
constraint ps_leash_chk_leash_length_positive
check (leash_length > 0),
breed_size_id int not null,
constraint ps_leash_breed_size_id_fk
foreign key(breed_size_id) references c_breed_size(id)
);


create table c_grooming_type (
id int not null unique auto_increment primary key,
grooming_type varchar(45) not null unique
);

create table ps_grooming (
product_id int not null primary key,
constraint ps_grooming_product_id
foreign key(product_id) references p_supply(product_id),
grooming_type_id int not null,
constraint ps_grooming_grooming_type_id_fk
foreign key(grooming_type_id) references c_grooming_type(id),
health_feature_id int not null,
constraint ps_grooming_health_feature_id_fk
foreign key(health_feature_id) references c_health_feature(id)
);

