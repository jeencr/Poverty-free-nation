"""
URL configuration for Poverty_Free_Nation_Django project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [
    path('view_public/',views.view_public),
    path('view_login/',views.view_login),
    path('view_adminhome/',views.view_adminhome),
    path('view_company_home/',views.view_company_home),
    path('view_skill_center_home/',views.view_skill_center_home),
    path('login_post/',views.login_post),
    path('skill_center_register_post/',views.skill_center_register_post),
    path('view_skill_center_register/',views.view_skill_center_register),
    path('company_registration_post/',views.company_registration_post),
    path('view_company_register/', views.view_company_register),
    path('reject_skill_center/<id>',views.reject_skill_center),
    path('accept_skill_center/<id>',views.accept_skill_center),
    path('view_new_skill_center',views.view_new_skill_center),
    path('view_approved_skill_centers/',views.view_approved_skill_centers),
    path('view_rejected_skill_centers/',views.view_rejected_skill_centers),

    path('reject_company/<id>', views.reject_company),
    path('accept_company/<id>', views.accept_company),
    path('view_new_company', views.view_new_company),
    path('view_approved_company/', views.view_approved_company),
    path('view_rejected_company/', views.view_rejected_company),
    path('view_vacancies_admin/',views.view_vacancies_admin),
    path('view_vacancy_result/',views.view_vacancy_result),
    path('get_programs/',views.get_programs),
    path('filter_programs/<id>',views.filter_programs),
    path('view_app_review/',views.view_app_review),
    path('view_compliant/',views.view_compliant),
    path('view_replay_complaint_get/<id>',views.view_replay_complaint_get),
    path('reply_complaint/<id>', views.reply_complaint),
    path('view_profile_skill/', views.view_profile_skill),
    path('edit_profile_skill_get',views.edit_profile_skill_get),
    path('edit_profile_skill_post', views.edit_profile_skill_post),
    path('add_program_view/',views.add_program_view),
    path('add_program_post/',views.add_program_post),
    path('view_programs_skill/',views.view_programs_skill),
    path('edit_program_skill_get/<id>',views.edit_program_skill_get),
    path('edit_program_skill_post/<id>',views.edit_program_skill_post),
    path('delete_program_skill/<id>',views.delete_program_skill),
    path('add_video_session/<id>',views.add_video_session_get),
    path('add_video_session_post/<id>',views.add_video_session_post),
    path('view_video_session/<id>',views.view_video_session),
    path('delete_video_session/<id>',views.delete_video_session_get),
    path('add_google_session_get/<id>',views.add_google_session_get),
    path('add_google_session_post/<id>',views.add_google_session_post),
    path('view_google_session/<id>',views.view_google_session),
    path('delete_google_session/<id>',views.delete_google_session_get),
    path('review_program_get/<id>',views.review_program_get),
    path('change_password_skill_get/',views.change_password_skill_get),
    path('change_password_skill_post/',views.change_password_skill_post),
    path('view_company_profile',views.view_company_profile),
    path('edit_company_profile_get',views.edit_company_profile_get),
    path('edit_company_profile_post',views.edit_company_profile_post),
    path('add_vacancy_get/',views.add_vacancy_get),
    path('add_vacancy_post',views.add_vacancy_post),
    path('view_vacancy/',views.view_vacancy),
    path('edit_vacancy_get/<id>',views.edit_vacancy_get),
    path('edit_vacancy_post/<id>',views.edit_vacancy_post),
    path('view_applications_company/',views.view_applications_company),
    path('reject_application/',views.reject_application),
    path('accept_application/', views.accept_application),
    path('register_user_post/', views.register_user_post),
    path('loginapp/', views.loginapp),
    path('user_data_get/', views.user_data_get),
    path('view_user_profile/',views.view_user_profile),
    path('edit_user_profile_get/',views.edit_user_profile_get),
    path('update_user_profile_post/',views.update_user_profile_post),
    path('change_password_user/',views.change_password_user),
    path('get_reviews_user/',views.get_reviews_user),
    path('add_review_user/',views.add_review_user),
    path('get_complaints_user/',views.get_complaints_user),
    path('add_complaint_user/',views.add_complaint_user),
    path('get_resumes_user/',views.get_resumes_user),
    path('upload_resume/',views.upload_resume),
    path('vacancy_user_get/',views.vacancy_user_get),
    path('apply_vacancy_user_get/',views.apply_vacancy_user_get),
    path('submit_vacancy_application/',views.submit_vacancy_application),
    path('view_applied_vacancies_user/',views.view_applied_vacancies_user),
    path('selected_notification_user/',views.selected_notification_user),

]
