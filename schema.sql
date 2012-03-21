CREATE TABLE page (
  id         int(10) unsigned    NOT NULL auto_increment,
  rid        varchar(255) binary NOT NULL default '',
  title      varchar(255)        NOT NULL,
  body       text                NOT NULL,
  created_at datetime            NOT NULL,
  updated_at timestamp           NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (id),
  UNIQUE KEY rid (rid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

