drop database if exists sip09;
create database sip09;
use sip09;

create table comment_target (
    id bigint unsigned not null auto_increment primary key,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp
) engine = InnoDb;

-- Hm, got IP addr 0:0:0:0:0:0:0:1%0 at Barnes & Noble. So I'm stretching out the ip_addr width. 
create table comment (
    id bigint unsigned not null auto_increment primary key,
    comment_target_id bigint unsigned not null,
    name varchar(100) not null,
    email varchar(100) not null,
    web varchar(100),
    ip_addr varchar(20) not null,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    markdown_text text not null,
    html_text text not null,
    foreign key (comment_target_id) references comment_target (id)
) engine = InnoDb;

create table article (
    id bigint unsigned not null auto_increment primary key,
    name varchar(100) not null,
    category varchar(50),
    title varchar(250) not null,
    author varchar(100) not null,
    deck varchar(250),
    description text(4000),
    keywords text(4000),
    comment_target_id bigint unsigned not null unique,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    foreign key (comment_target_id) references comment_target (id)
) engine = InnoDb;

create table article_page (
    id bigint unsigned not null auto_increment primary key,
    article_id bigint unsigned not null,
    page_number int(4) not null,
    title varchar(250) not null,
    date_created timestamp default 0,
    date_modified timestamp default current_timestamp on update current_timestamp,
    body text not null,
    foreign key (article_id) references article (id),
    unique index article_page_idx1 (article_id, page_number)
) engine = InnoDb;
