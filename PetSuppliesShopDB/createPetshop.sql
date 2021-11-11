create table c_active_ingredient
(
    id                int auto_increment,
    active_ingredient varchar(45) not null,
    constraint active_ingredient
        unique (active_ingredient),
    constraint id
        unique (id)
);

alter table c_active_ingredient
    add primary key (id);

create table c_body_weight
(
    id         int auto_increment,
    min_weight double not null,
    max_weight double not null,
    constraint id
        unique (id)
);

alter table c_body_weight
    add primary key (id);

create table c_breed_size
(
    id         int auto_increment,
    breed_size varchar(45) not null,
    constraint breed_size
        unique (breed_size),
    constraint id
        unique (id)
);

alter table c_breed_size
    add primary key (id);

create table c_food_flavour
(
    id      int auto_increment,
    flavour varchar(45) not null,
    constraint flavour
        unique (flavour),
    constraint id
        unique (id)
);

alter table c_food_flavour
    add primary key (id);

create table c_food_form
(
    id        int auto_increment,
    food_form varchar(45) not null,
    constraint food_form
        unique (food_form),
    constraint id
        unique (id)
);

alter table c_food_form
    add primary key (id);

create table c_food_type
(
    id        int auto_increment,
    food_type varchar(45) not null,
    constraint food_type
        unique (food_type),
    constraint id
        unique (id)
);

alter table c_food_type
    add primary key (id);

create table c_grooming_type
(
    id            int auto_increment,
    grooming_type varchar(45) not null,
    constraint grooming_type
        unique (grooming_type),
    constraint id
        unique (id)
);

alter table c_grooming_type
    add primary key (id);

create table c_health_feature
(
    id             int auto_increment,
    health_feature varchar(45) not null,
    constraint health_feature
        unique (health_feature),
    constraint id
        unique (id)
);

alter table c_health_feature
    add primary key (id);

create table c_leash_type
(
    id         int auto_increment,
    leash_type varchar(45) not null,
    constraint id
        unique (id),
    constraint leash_type
        unique (leash_type)
);

alter table c_leash_type
    add primary key (id);

create table c_lifestage
(
    id        int auto_increment,
    lifestage varchar(45) not null,
    constraint id
        unique (id),
    constraint lifestage
        unique (lifestage)
);

alter table c_lifestage
    add primary key (id);

create table c_medication_form
(
    id              int auto_increment,
    medication_form varchar(45) not null,
    constraint id
        unique (id),
    constraint medication_form
        unique (medication_form)
);

alter table c_medication_form
    add primary key (id);

create table c_medication_type
(
    id              int auto_increment,
    medication_type varchar(45) not null,
    constraint id
        unique (id),
    constraint medication_type
        unique (medication_type)
);

alter table c_medication_type
    add primary key (id);

create table c_order_status
(
    id           int auto_increment,
    order_status varchar(45) not null,
    constraint id
        unique (id),
    constraint order_status
        unique (order_status)
);

alter table c_order_status
    add primary key (id);

create table c_payment_type
(
    id           int auto_increment,
    payment_type varchar(45) not null,
    constraint id
        unique (id),
    constraint payment_type
        unique (payment_type)
);

alter table c_payment_type
    add primary key (id);

create table c_product_availability
(
    id           int auto_increment,
    availability varchar(45) not null,
    constraint availability
        unique (availability),
    constraint id
        unique (id)
);

alter table c_product_availability
    add primary key (id);

create table c_product_brand
(
    id         int auto_increment,
    brand_name varchar(45) null,
    constraint brand_name
        unique (brand_name),
    constraint id
        unique (id)
);

alter table c_product_brand
    add primary key (id);

create table c_special_diet
(
    id           int auto_increment,
    special_diet varchar(45) not null,
    constraint id
        unique (id),
    constraint special_diet
        unique (special_diet)
);

alter table c_special_diet
    add primary key (id);

create table c_supply_colour
(
    id            int auto_increment,
    supply_colour varchar(45) not null,
    constraint id
        unique (id),
    constraint supply_colour
        unique (supply_colour)
);

alter table c_supply_colour
    add primary key (id);

create table c_supply_feature
(
    id             int auto_increment,
    supply_feature varchar(45) not null,
    constraint id
        unique (id),
    constraint supply_feature
        unique (supply_feature)
);

alter table c_supply_feature
    add primary key (id);

create table c_supply_material
(
    id              int auto_increment,
    supply_material varchar(45) not null,
    constraint id
        unique (id),
    constraint supply_material
        unique (supply_material)
);

alter table c_supply_material
    add primary key (id);

create table c_toy_collection
(
    id             int auto_increment,
    toy_collection varchar(45) not null,
    constraint id
        unique (id),
    constraint toy_collection
        unique (toy_collection)
);

alter table c_toy_collection
    add primary key (id);

create table c_toy_type
(
    id       int auto_increment,
    toy_type varchar(45) not null,
    constraint id
        unique (id),
    constraint toy_type
        unique (toy_type)
);

alter table c_toy_type
    add primary key (id);

create table country
(
    id           int auto_increment,
    country_name varchar(45) not null,
    iso_code     varchar(2)  null,
    constraint country_country_name_uindex
        unique (country_name),
    constraint id
        unique (id)
);

alter table country
    add primary key (id);

create table customer
(
    customer_id   int auto_increment,
    first_name    varchar(45) not null,
    last_name     varchar(45) not null,
    email_address varchar(45) not null,
    phone_number  varchar(13) not null,
    constraint customer_email_address_uindex
        unique (email_address),
    constraint customer_id
        unique (customer_id)
);

alter table customer
    add primary key (customer_id);

create table delivery_address
(
    id           int auto_increment,
    country_id   int                      not null,
    city         varchar(45) charset utf8 not null,
    street       varchar(45) charset utf8 not null,
    house_number int                      not null,
    constraint id
        unique (id),
    constraint delivery_address_country_id_fk
        foreign key (country_id) references country (id)
);

alter table delivery_address
    add primary key (id);

create table customer_user
(
    customer_id             int                  not null,
    delivery_address_id     int                  not null,
    fidelity_reward_points  int        default 0 null,
    newsletter_subscription tinyint(1) default 0 null,
    constraint customer_user_customer_id_uindex
        unique (customer_id),
    constraint customer_user_customer_id_fk
        foreign key (customer_id) references customer (customer_id),
    constraint customer_user_delivery_address_id_fk
        foreign key (delivery_address_id) references delivery_address (id)
);

alter table customer_user
    add primary key (customer_id);

create table log_in
(
    customer_id   int         not null,
    username      varchar(45) not null,
    user_password varchar(45) not null,
    constraint log_in_customer_id_uindex
        unique (customer_id),
    constraint username
        unique (username),
    constraint log_in_customer_id_fk
        foreign key (customer_id) references customer_user (customer_id)
);

alter table log_in
    add primary key (customer_id);

create table order_form
(
    order_id            int auto_increment,
    customer_id         int              not null,
    order_status_id     int              not null,
    total               double default 0 null,
    delivery_address_id int              not null,
    order_date          date             not null,
    payment_type_id     int    default 1 null,
    constraint order_id
        unique (order_id),
    constraint order_form_customer_id_fk
        foreign key (customer_id) references customer (customer_id),
    constraint order_form_delivery_address_id_fk
        foreign key (delivery_address_id) references delivery_address (id),
    constraint order_form_order_staus_id_fk
        foreign key (order_status_id) references c_order_status (id),
    constraint order_form_payment_type_id_fk
        foreign key (payment_type_id) references c_payment_type (id)
);

alter table order_form
    add primary key (order_id);

create table product
(
    product_id      int auto_increment,
    product_name    varchar(45)   not null,
    price           double        not null,
    availability_id int           not null,
    brand_id        int           not null,
    customer_rating int default 1 null,
    constraint id
        unique (product_id),
    constraint product_availability_id_fk
        foreign key (availability_id) references c_product_availability (id),
    constraint product_brand_id_fk
        foreign key (brand_id) references c_product_brand (id)
);

alter table product
    add primary key (product_id);

create table ordered_product
(
    order_id         int           not null,
    product_id       int           not null,
    product_quantity int default 1 null,
    primary key (order_id, product_id),
    constraint ordered_product_order_id_fk
        foreign key (order_id) references order_form (order_id),
    constraint ordered_product_product_id_fk
        foreign key (product_id) references product (product_id)
);

create table p_health
(
    product_id        int not null,
    lifestage_id      int not null,
    body_weight_id    int not null,
    special_diet_id   int not null,
    health_feature_id int not null,
    constraint p_health_product_id_uindex
        unique (product_id),
    constraint p_health_body_weight_id_fk
        foreign key (body_weight_id) references c_body_weight (id),
    constraint p_health_health_feature_fk
        foreign key (health_feature_id) references c_health_feature (id),
    constraint p_health_lifestage_id_fk
        foreign key (lifestage_id) references c_lifestage (id),
    constraint p_health_product_id_fk
        foreign key (product_id) references product (product_id),
    constraint p_health_special_diet_id_fk
        foreign key (special_diet_id) references c_special_diet (id)
);

alter table p_health
    add primary key (product_id);

create table p_supply
(
    product_id         int not null,
    supply_feature_id  int not null,
    supply_material_id int not null,
    supply_colour_id   int not null,
    constraint p_supply_product_id_uindex
        unique (product_id),
    constraint p_supply_product_id_fk
        foreign key (product_id) references product (product_id),
    constraint p_supply_supply_colour_id_fk
        foreign key (supply_colour_id) references c_supply_colour (id),
    constraint p_supply_supply_feature_id_fk
        foreign key (supply_feature_id) references c_supply_feature (id),
    constraint p_supply_supply_material_id_fk
        foreign key (supply_material_id) references c_supply_material (id)
);

alter table p_supply
    add primary key (product_id);

create table ph_food
(
    product_id      int    not null,
    food_flavour_id int    not null,
    food_form_id    int    not null,
    food_type_id    int    not null,
    quantity        double not null,
    constraint ph_food_product_id_uindex
        unique (product_id),
    constraint ph_food_food_flavour_id_fk
        foreign key (food_flavour_id) references c_food_flavour (id),
    constraint ph_food_food_form_id_fk
        foreign key (food_form_id) references c_food_form (id),
    constraint ph_food_food_type_id_fk
        foreign key (food_type_id) references c_food_type (id),
    constraint ph_food_product_id_fk
        foreign key (product_id) references p_health (product_id)
);

alter table ph_food
    add primary key (product_id);

create table ph_healthcare
(
    product_id           int not null,
    active_ingredient_id int not null,
    medication_form_id   int not null,
    medication_type_id   int not null,
    constraint ph_healthcare_product_id_uindex
        unique (product_id),
    constraint ph_healthcare_active_ingredient_id_fk
        foreign key (active_ingredient_id) references c_active_ingredient (id),
    constraint ph_healthcare_medication_form_id_fk
        foreign key (medication_form_id) references c_medication_form (id),
    constraint ph_healthcare_medication_type_id_fk
        foreign key (medication_type_id) references c_medication_type (id),
    constraint ph_healthcare_product_id_fk
        foreign key (product_id) references p_health (product_id)
);

alter table ph_healthcare
    add primary key (product_id);

create table ps_grooming
(
    product_id        int not null,
    grooming_type_id  int not null,
    health_feature_id int not null,
    constraint ps_grooming_product_id_uindex
        unique (product_id),
    constraint ps_grooming_grooming_type_id_fk
        foreign key (grooming_type_id) references c_grooming_type (id),
    constraint ps_grooming_health_feature_id_fk
        foreign key (health_feature_id) references c_health_feature (id),
    constraint ps_grooming_product_id
        foreign key (product_id) references p_supply (product_id)
);

alter table ps_grooming
    add primary key (product_id);

create table ps_leash
(
    product_id    int    not null,
    leash_type_id int    not null,
    leash_length  double not null,
    breed_size_id int    not null,
    constraint ps_leash_product_id_uindex
        unique (product_id),
    constraint ps_leash_breed_size_id_fk
        foreign key (breed_size_id) references c_breed_size (id),
    constraint ps_leash_leash_type_id_fk
        foreign key (leash_type_id) references c_leash_type (id),
    constraint ps_leash_product_id_fk
        foreign key (product_id) references p_supply (product_id)
);

alter table ps_leash
    add primary key (product_id);

create table ps_toy
(
    product_id        int not null,
    toy_type_id       int not null,
    lifestage_id      int not null,
    toy_collection_id int not null,
    constraint ps_toy_product_id_uindex
        unique (product_id),
    constraint ps_toy_lifestage_id_fk
        foreign key (lifestage_id) references c_lifestage (id),
    constraint ps_toy_product_id_fk
        foreign key (product_id) references p_supply (product_id),
    constraint ps_toy_toy_collection_id_fk
        foreign key (toy_collection_id) references c_toy_collection (id),
    constraint ps_toy_toy_type_id_fk
        foreign key (toy_type_id) references c_toy_type (id)
);

alter table ps_toy
    add primary key (product_id);


