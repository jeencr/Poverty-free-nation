/*
SQLyog Community v13.1.6 (64 bit)
MySQL - 9.1.0 : Database - poverty_free_nation_db
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`poverty_free_nation_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `poverty_free_nation_db`;

/*Data for the table `auth_group` */

insert  into `auth_group`(`id`,`name`) values 
(1,'normaluser'),
(2,'admin'),
(3,'company'),
(4,'skillcenter');

/*Data for the table `auth_group_permissions` */

/*Data for the table `auth_permission` */

insert  into `auth_permission`(`id`,`name`,`content_type_id`,`codename`) values 
(1,'Can add log entry',1,'add_logentry'),
(2,'Can change log entry',1,'change_logentry'),
(3,'Can delete log entry',1,'delete_logentry'),
(4,'Can view log entry',1,'view_logentry'),
(5,'Can add permission',2,'add_permission'),
(6,'Can change permission',2,'change_permission'),
(7,'Can delete permission',2,'delete_permission'),
(8,'Can view permission',2,'view_permission'),
(9,'Can add group',3,'add_group'),
(10,'Can change group',3,'change_group'),
(11,'Can delete group',3,'delete_group'),
(12,'Can view group',3,'view_group'),
(13,'Can add user',4,'add_user'),
(14,'Can change user',4,'change_user'),
(15,'Can delete user',4,'delete_user'),
(16,'Can view user',4,'view_user'),
(17,'Can add content type',5,'add_contenttype'),
(18,'Can change content type',5,'change_contenttype'),
(19,'Can delete content type',5,'delete_contenttype'),
(20,'Can view content type',5,'view_contenttype'),
(21,'Can add session',6,'add_session'),
(22,'Can change session',6,'change_session'),
(23,'Can delete session',6,'delete_session'),
(24,'Can view session',6,'view_session'),
(25,'Can add company profile',7,'add_companyprofile'),
(26,'Can change company profile',7,'change_companyprofile'),
(27,'Can delete company profile',7,'delete_companyprofile'),
(28,'Can view company profile',7,'view_companyprofile'),
(29,'Can add crowd funding request',8,'add_crowdfundingrequest'),
(30,'Can change crowd funding request',8,'change_crowdfundingrequest'),
(31,'Can delete crowd funding request',8,'delete_crowdfundingrequest'),
(32,'Can view crowd funding request',8,'view_crowdfundingrequest'),
(33,'Can add help request',9,'add_helprequest'),
(34,'Can change help request',9,'change_helprequest'),
(35,'Can delete help request',9,'delete_helprequest'),
(36,'Can view help request',9,'view_helprequest'),
(37,'Can add normal user',10,'add_normaluser'),
(38,'Can change normal user',10,'change_normaluser'),
(39,'Can delete normal user',10,'delete_normaluser'),
(40,'Can view normal user',10,'view_normaluser'),
(41,'Can add program',11,'add_program'),
(42,'Can change program',11,'change_program'),
(43,'Can delete program',11,'delete_program'),
(44,'Can view program',11,'view_program'),
(45,'Can add vacancy',12,'add_vacancy'),
(46,'Can change vacancy',12,'change_vacancy'),
(47,'Can delete vacancy',12,'delete_vacancy'),
(48,'Can view vacancy',12,'view_vacancy'),
(49,'Can add skill center profile',13,'add_skillcenterprofile'),
(50,'Can change skill center profile',13,'change_skillcenterprofile'),
(51,'Can delete skill center profile',13,'delete_skillcenterprofile'),
(52,'Can view skill center profile',13,'view_skillcenterprofile'),
(53,'Can add resume',14,'add_resume'),
(54,'Can change resume',14,'change_resume'),
(55,'Can delete resume',14,'delete_resume'),
(56,'Can view resume',14,'view_resume'),
(57,'Can add program video',15,'add_programvideo'),
(58,'Can change program video',15,'change_programvideo'),
(59,'Can delete program video',15,'delete_programvideo'),
(60,'Can view program video',15,'view_programvideo'),
(61,'Can add program review',16,'add_programreview'),
(62,'Can change program review',16,'change_programreview'),
(63,'Can delete program review',16,'delete_programreview'),
(64,'Can view program review',16,'view_programreview'),
(65,'Can add program class',17,'add_programclass'),
(66,'Can change program class',17,'change_programclass'),
(67,'Can delete program class',17,'delete_programclass'),
(68,'Can view program class',17,'view_programclass'),
(69,'Can add notification',18,'add_notification'),
(70,'Can change notification',18,'change_notification'),
(71,'Can delete notification',18,'delete_notification'),
(72,'Can view notification',18,'view_notification'),
(73,'Can add help response',19,'add_helpresponse'),
(74,'Can change help response',19,'change_helpresponse'),
(75,'Can delete help response',19,'delete_helpresponse'),
(76,'Can view help response',19,'view_helpresponse'),
(77,'Can add donation',20,'add_donation'),
(78,'Can change donation',20,'change_donation'),
(79,'Can delete donation',20,'delete_donation'),
(80,'Can view donation',20,'view_donation'),
(81,'Can add complaint',21,'add_complaint'),
(82,'Can change complaint',21,'change_complaint'),
(83,'Can delete complaint',21,'delete_complaint'),
(84,'Can view complaint',21,'view_complaint'),
(85,'Can add app review',22,'add_appreview'),
(86,'Can change app review',22,'change_appreview'),
(87,'Can delete app review',22,'delete_appreview'),
(88,'Can view app review',22,'view_appreview'),
(89,'Can add application',23,'add_application'),
(90,'Can change application',23,'change_application'),
(91,'Can delete application',23,'delete_application'),
(92,'Can view application',23,'view_application'),
(93,'Can add published results',24,'add_publishedresults'),
(94,'Can change published results',24,'change_publishedresults'),
(95,'Can delete published results',24,'delete_publishedresults'),
(96,'Can view published results',24,'view_publishedresults');

/*Data for the table `auth_user` */

insert  into `auth_user`(`id`,`password`,`last_login`,`is_superuser`,`username`,`first_name`,`last_name`,`email`,`is_staff`,`is_active`,`date_joined`) values 
(1,'pbkdf2_sha256$1000000$763Ywc5kCcqfxExNVJToYu$EqgaXgaQJKnqQX0Zyypp981cpPBBeBhssZWNTSlW8CQ=','2025-09-27 08:59:19.542732',1,'poverty','','','',1,1,'2025-09-26 11:15:06.000000'),
(3,'pbkdf2_sha256$1000000$jgjw5az8RtLT0zQ84vonac$FquEuN54xKLqOOpVQUBzShi2RGnGcNjC2vCw14wi4YY=','2025-09-27 07:29:29.101715',0,'skill1','','','',0,1,'2025-09-27 05:34:03.655725'),
(4,'pbkdf2_sha256$1000000$LCtWJ3Genv4yoRl79yoEFF$awQbWqGvKGYbrqZY1yBqy8h3bB+6Gekf8JLi6WkMJIM=',NULL,0,'skill2','','','',0,1,'2025-09-27 05:36:14.603818'),
(7,'pbkdf2_sha256$1000000$BlGiB0D8i8IYA5C9ZHDgzM$yHrr84Ey+w+uy6GjEjlUPJl++9l1PgG8kDz2fKCRzh0=',NULL,0,'company1','','','',0,1,'2025-09-27 08:53:57.296406'),
(6,'pbkdf2_sha256$1000000$INTKzSdKTGtk3mAicvKntF$fsKSQTHDl8jtQtLhWMsnnNyuLIA2j6PO2nfnvLf1B7U=','2025-09-27 06:36:55.429024',0,'skill3','','','',0,1,'2025-09-27 06:26:39.608963');

/*Data for the table `auth_user_groups` */

insert  into `auth_user_groups`(`id`,`user_id`,`group_id`) values 
(1,1,2),
(2,3,4),
(3,4,4),
(4,5,3),
(5,6,4),
(6,7,3);

/*Data for the table `auth_user_user_permissions` */

/*Data for the table `django_admin_log` */

insert  into `django_admin_log`(`id`,`action_time`,`object_id`,`object_repr`,`action_flag`,`change_message`,`content_type_id`,`user_id`) values 
(1,'2025-09-26 11:15:56.598805','1','normaluser',1,'[{\"added\": {}}]',3,1),
(2,'2025-09-26 11:16:06.225214','2','admin',1,'[{\"added\": {}}]',3,1),
(3,'2025-09-26 11:16:46.852773','3','company',1,'[{\"added\": {}}]',3,1),
(4,'2025-09-26 11:16:59.249725','4','skillcenter',1,'[{\"added\": {}}]',3,1),
(5,'2025-09-26 11:17:15.829369','1','poverty',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,1);

/*Data for the table `django_content_type` */

insert  into `django_content_type`(`id`,`app_label`,`model`) values 
(1,'admin','logentry'),
(2,'auth','permission'),
(3,'auth','group'),
(4,'auth','user'),
(5,'contenttypes','contenttype'),
(6,'sessions','session'),
(7,'myapp','companyprofile'),
(8,'myapp','crowdfundingrequest'),
(9,'myapp','helprequest'),
(10,'myapp','normaluser'),
(11,'myapp','program'),
(12,'myapp','vacancy'),
(13,'myapp','skillcenterprofile'),
(14,'myapp','resume'),
(15,'myapp','programvideo'),
(16,'myapp','programreview'),
(17,'myapp','programclass'),
(18,'myapp','notification'),
(19,'myapp','helpresponse'),
(20,'myapp','donation'),
(21,'myapp','complaint'),
(22,'myapp','appreview'),
(23,'myapp','application'),
(24,'myapp','publishedresults');

/*Data for the table `django_migrations` */

insert  into `django_migrations`(`id`,`app`,`name`,`applied`) values 
(1,'contenttypes','0001_initial','2025-09-26 11:11:33.778825'),
(2,'auth','0001_initial','2025-09-26 11:11:34.137701'),
(3,'admin','0001_initial','2025-09-26 11:11:34.262742'),
(4,'admin','0002_logentry_remove_auto_add','2025-09-26 11:11:34.268747'),
(5,'admin','0003_logentry_add_action_flag_choices','2025-09-26 11:11:34.275746'),
(6,'contenttypes','0002_remove_content_type_name','2025-09-26 11:11:34.324257'),
(7,'auth','0002_alter_permission_name_max_length','2025-09-26 11:11:34.352794'),
(8,'auth','0003_alter_user_email_max_length','2025-09-26 11:11:34.383798'),
(9,'auth','0004_alter_user_username_opts','2025-09-26 11:11:34.388795'),
(10,'auth','0005_alter_user_last_login_null','2025-09-26 11:11:34.411202'),
(11,'auth','0006_require_contenttypes_0002','2025-09-26 11:11:34.413225'),
(12,'auth','0007_alter_validators_add_error_messages','2025-09-26 11:11:34.419200'),
(13,'auth','0008_alter_user_username_max_length','2025-09-26 11:11:34.444309'),
(14,'auth','0009_alter_user_last_name_max_length','2025-09-26 11:11:34.470205'),
(15,'auth','0010_alter_group_name_max_length','2025-09-26 11:11:34.495651'),
(16,'auth','0011_update_proxy_permissions','2025-09-26 11:11:34.502649'),
(17,'auth','0012_alter_user_first_name_max_length','2025-09-26 11:11:34.524925'),
(18,'myapp','0001_initial','2025-09-26 11:11:35.634568'),
(19,'sessions','0001_initial','2025-09-26 11:11:35.671183');

/*Data for the table `django_session` */

insert  into `django_session`(`session_key`,`session_data`,`expire_date`) values 
('nnt9sz9lv42i2t00il48v5a8afi6ntdm','.eJxVjMsOwiAQRf-FtSGlgzxcuvcbyMwAUjWQlHZl_HfbpAvd3nPueYuA61LC2tMcpiguQonT70bIz1R3EB9Y701yq8s8kdwVedAuby2m1_Vw_wIFe9ne3iIDsFFoRxxcHpyxg0fQDmJmjg4To3JbMGmTSIGliCOdgTzlrLP4fAHz8DkX:1v2Qlz:vf-OAz4f7xXjjLXjoHBfkdcwkfrD9omaNXGUxw3rWuc','2025-10-11 08:59:19.545615');

/*Data for the table `myapp_application` */

/*Data for the table `myapp_appreview` */

/*Data for the table `myapp_companyprofile` */

insert  into `myapp_companyprofile`(`id`,`company_name`,`address`,`email`,`photo`,`phone`,`approval_status`,`LOGIN_id`) values 
(1,'company1','company1jhgedhj','company1@gmail.com','download_2_m0ifH1N.jpg','438733789','approved',7);

/*Data for the table `myapp_complaint` */

/*Data for the table `myapp_crowdfundingrequest` */

/*Data for the table `myapp_donation` */

/*Data for the table `myapp_helprequest` */

/*Data for the table `myapp_helpresponse` */

/*Data for the table `myapp_normaluser` */

/*Data for the table `myapp_notification` */

/*Data for the table `myapp_program` */

/*Data for the table `myapp_programclass` */

/*Data for the table `myapp_programreview` */

/*Data for the table `myapp_programvideo` */

/*Data for the table `myapp_resume` */

/*Data for the table `myapp_skillcenterprofile` */

insert  into `myapp_skillcenterprofile`(`id`,`name`,`address`,`phone`,`approval_status`,`email`,`photo`,`LOGIN_id`) values 
(2,'skill1','sncsklk','75899329','approved','dhjs@gmail.com','download_1.jpg',3),
(3,'skill2','sdhcjsd','34528581','approved','skll2@gmail.com','download_2.jpg',4),
(5,'skill3','skill3','74823727','rejected','skill3@gmail.com','1930813.jpg',6);

/*Data for the table `myapp_vacancy` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
