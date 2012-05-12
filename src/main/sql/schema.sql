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
    text text not null,
    foreign key (comment_target_id) references comment_target (id)
) engine = InnoDb;
