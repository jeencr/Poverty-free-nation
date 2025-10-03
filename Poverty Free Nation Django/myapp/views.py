from datetime import datetime

from django.contrib import messages
from django.contrib.auth import authenticate, login
from django.contrib.auth.hashers import check_password
from django.contrib.auth.models import Group
from django.http import JsonResponse, response
from django.shortcuts import render, redirect
from myapp.models import *


# Create your views here.
def view_public(request):
    return render(request, 'public.html')
def view_login(request):
    return render(request, 'login.html')

def view_adminhome(request):
    return render(request, 'adminhome.html')

def view_company_home(request):
    return render(request, 'company_home.html')

def view_skill_center_home(request):
    return render(request, 'skill_center_home.html')

def login_post(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        print(username)
        print(password)
        user = authenticate(request, username=username, password=password)
        if user is not None:
            if user.groups.filter(name='admin').exists():
                login(request, user)
                messages.success(request, 'You are now logged in as admin')
                return redirect('/myapp/view_adminhome/', {'message': 'Login successful!'})
            elif user.groups.filter(name='company').exists():
                login(request, user)
                if not CompanyProfile.objects.filter(LOGIN_id=user.id, approval_status='approved').exists():
                    messages.error(request, 'Your company registration is still pending or has been rejected.')
                    return redirect('/myapp/view_login/')
                login(request, user)
                messages.success(request, 'Login successful!')
                return redirect('/myapp/view_company_home/')

            elif user.groups.filter(name='skillcenter').exists():
                if not SkillCenterProfile.objects.filter(LOGIN_id=user.id, approval_status='approved').exists():
                    messages.error(request, 'Your skill center registration is still pending or has been rejected.')
                    return redirect('/myapp/view_login/')
                login(request, user)
                messages.success(request, 'Login successful!')
                return redirect('/myapp/view_skill_center_home/')

            else:
                messages.error(request, 'blocked')
                return redirect('/myapp/view_login/')

        else:
            messages.error(request, 'Username or password is incorrect')
            return render(request, 'login.html', {'error': 'Invalid username or password.'})


# admin function
def view_skill_center_register(request):
    return render(request, 'SkillCenterRegisteration.html')

def skill_center_register_post(request):
    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        phone = request.POST['phone']
        address = request.POST['address']
        username = request.POST['username']
        password = request.POST['password']
        photo = request.FILES['photo']
        if User.objects.filter(username=username).exists():
            return render(request, 'SkillCenterRegisteration.html', {'error': 'Username already exists.'})
        user = User.objects.create_user(username=username, password=password)
        skill_center = SkillCenterProfile(name=name,    address=address,  phone=phone,
                                          approval_status='pending',  email=email,   photo=photo,
                                          LOGIN_id=user.id )
        skill_center.save()
        messages.success(request, 'Skill Center Registered Successfully.')
        return redirect("/myapp/view_public")

def view_company_register(request):
    return render(request, 'company_registration.html')

def company_registration_post(request):
    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        phone = request.POST['phone']
        address = request.POST['address']
        username = request.POST['username']
        password = request.POST['password']
        photo = request.FILES['photo']
        if User.objects.filter(username=username).exists():
            messages.success(request, 'Username already exists.')
            return redirect('/myapp/view_company_register')
        user = User.objects.create_user(username=username, password=password)
        skill_center = CompanyProfile(company_name=name,    address=address,  phone=phone,
                                          approval_status='pending',  email=email,   photo=photo,
                                          LOGIN_id=user.id )
        skill_center.save()
        messages.success(request, 'Company Registered Successfully.')
        return redirect("/myapp/view_public")

def view_new_skill_center(request):
    skill_centers = SkillCenterProfile.objects.filter(approval_status='pending')
    return render(request, 'new_skill_center.html', {'skill_centers': skill_centers})

def reject_skill_center(request, id):
    skill_center = SkillCenterProfile.objects.get(id=id)
    skill_center.approval_status = 'rejected'
    skill_center.save()
    messages.success(request, 'Skill Center Rejected Successfully.')
    return redirect(request.META.get('HTTP_REFERER', '/'))

def accept_skill_center(request, id):
    skill_center = SkillCenterProfile.objects.get(id=id)
    skill_center.approval_status = 'approved'
    skill_center.save()
    user = User.objects.get(id=skill_center.LOGIN_id)
    user.groups.add(Group.objects.get(name='skillcenter'))
    user.save()
    messages.success(request, 'Skill Center Approved Successfully.')
    return redirect(request.META.get('HTTP_REFERER', '/'))

def view_approved_skill_centers(request):
    skill_centers = SkillCenterProfile.objects.filter(approval_status='approved')
    return render(request, 'approved_skill.html', {'skill_centers': skill_centers})

def view_rejected_skill_centers(request):
    skill_centers = SkillCenterProfile.objects.filter(approval_status='rejected')
    return render(request, 'rejected_skill.html', {'skill_centers': skill_centers})

def view_new_company(request):
    company = CompanyProfile.objects.filter(approval_status='pending')
    return render(request, 'new_company.html', {'company': company})

def reject_company(request, id):
    company = CompanyProfile.objects.get(id=id)
    company.approval_status = 'rejected'
    company.save()
    messages.success(request, 'Rejected Successfully.')
    return redirect(request.META.get('HTTP_REFERER', '/'))

def accept_company(request, id):
    company = CompanyProfile.objects.get(id=id)
    company.approval_status = 'approved'
    company.save()
    user = User.objects.get(id=company.LOGIN_id)
    user.groups.add(Group.objects.get(name='company'))
    user.save()
    messages.success(request, ' Approved Successfully.')
    return redirect(request.META.get('HTTP_REFERER', '/'))

def view_approved_company(request):
    company = CompanyProfile.objects.filter(approval_status='approved')
    return render(request, 'approved_company.html', {'company': company})

def view_rejected_company(request):
    company = CompanyProfile.objects.filter(approval_status='rejected')
    return render(request, 'rejected_company.html', {'company': company})

def view_vacancies_admin(request):
    vacancy = Vacancy.objects.all()
    return render(request, 'view_vacancies_admin.html', {'vacancy': vacancy})

def view_vacancy_result(request,id):
    published_results = PublishedResults.objects.filter(vacancy_id=id)
    return render(request, 'view_vacancy_result.html', {'published_results': published_results})

def get_programs(request):
    skill_centers = SkillCenterProfile.objects.filter(approval_status='approved')
    programs = Program.objects.all()
    return render(request, 'view_programs.html', {'programs': programs,
                                                  'skill_centers': skill_centers})
def filter_programs(request,id):
    skill_centers = SkillCenterProfile.objects.filter(approval_status='approved')
    programs = Program.objects.filter(skill_center_id=id)
    return render(request, 'view_programs.html', {'programs': programs,'skill_centers': skill_centers})

def view_app_review(request):
    reviews = AppReview.objects.all()
    return render(request, 'view_app_review.html', {'reviews': reviews})

def view_compliant(request):
    complaints = Complaint.objects.all()
    return render(request, 'view_complaint.html', {'complaints': complaints})

def view_replay_complaint_get(request,id):
    complaints = Complaint.objects.get(id=id)
    return render(request, 'reply_complaint.html', {'complaints': complaints})
def reply_complaint(request, id):
    if request.method == 'POST':
        reply_text = request.POST['reply_text']
        complaint = Complaint.objects.get(id=id)
        complaint.reply_text = reply_text
        complaint.status = 'replied'
        print(request.POST)
        complaint.save()
        messages.success(request, 'Replied Successfully.')
        return redirect('/myapp/view_complaint/')
    else:
        complaint = Complaint.objects.get(id=id)
        return render(request, 'reply_complaint.html', {'complaint': complaint})


def admin_change_password_get(request):
    return render(request,"change_password_admin.html")


def admin_change_pass_post(request):
    if request.method == "POST":
        current_password = request.POST["current_password"]
        new_password = request.POST["new_password"]
        confirm_password = request.POST["confirm_password"]
        user = request.user
        if not check_password(current_password, user.password):
            messages.error(request, "Current password is incorrect.")
            return redirect("/myapp/changepassword")

        user.set_password(new_password)
        user.save()
        messages.success(request, "Password changed successfully.")
        return redirect("/myapp/view_login/")

    return render(request,'change_password_admin.html')

def view_profile_skill(request):
    skill_center = SkillCenterProfile.objects.get(LOGIN_id=request.user.id)
    return render(request,'SkillCenterProfile.html', {'skill_center': skill_center})

def edit_profile_skill_get(request):
    skill_center = SkillCenterProfile.objects.get(LOGIN_id=request.user.id)
    return render(request,'editProfileSkill.html', {'skill_center': skill_center})

def edit_profile_skill_post(request):
    profile = SkillCenterProfile.objects.get(LOGIN_id=request.user.id)

    if request.method == "POST":
        name = request.POST['name']
        phone = request.POST['phone']
        email = request.POST['email']
        address = request.POST['address']

        profile.name = name
        profile.phone = phone
        profile.email = email
        profile.address = address
        if 'photo' in request.FILES:
            profile.photo = request.FILES['photo']

        profile.save()
        messages.success(request, 'Profile Updated Successfully.')
        return redirect('/myapp/view_profile_skill/')

def add_program_view(request):
    return render(request,'AddProgramsSkill.html')

def add_program_post(request):
    skillCenter_id=SkillCenterProfile.objects.get(LOGIN_id=request.user.id).id
    if request.method == "POST":
        title = request.POST['title']
        description = request.POST['description']
        start_date = request.POST['start_date']
        end_date = request.POST['end_date']
        Program.objects.create(title=title, description=description, start_date=start_date, end_date=end_date,skill_center_id=skillCenter_id)
        messages.success(request, 'Program Added Successfully.')
        return redirect('/myapp/add_program_view/')

def view_programs_skill(request):
    programs = Program.objects.filter(skill_center_id=SkillCenterProfile.objects.get(LOGIN_id=request.user.id).id)
    return render(request,'view_programs_skill.html', {'programs': programs})

def edit_program_skill_get(request,id):
    program = Program.objects.get(id=id)
    return render(request,'edit_program_skill.html', {'program': program})

def edit_program_skill_post(request,id):
    program = Program.objects.get(id=id)
    if request.method == "POST":
        program.title = request.POST['title']
        program.description = request.POST['description']
        program.start_date = request.POST['start_date']
        program.end_date = request.POST['end_date']
        program.save()
        messages.success(request, 'Program Updated Successfully.')
        return redirect('/myapp/view_programs_skill/')

def delete_program_skill(request,id):
    program = Program.objects.get(id=id)
    program.delete()
    messages.success(request, 'Program Deleted Successfully.')
    return redirect('/myapp/view_programs_skill/')

def add_video_session_get(request,id):
    program = Program.objects.get(id=id)
    return render(request,'add_video_session.html', {'program': program})

def add_video_session_post(request,id):
    program = Program.objects.get(id=id)
    if request.method == "POST":
        title = request.POST['title']
        video = request.FILES['video']
        program_video = ProgramVideo.objects.create(title=title, video=video, program_id=program.id,uploaded_at=datetime.today())
        program_video.save()
        messages.success(request, 'Video Session Added Successfully.')
        return redirect(f'/myapp/add_video_session/{id}')

def view_video_session(request,id):
    program = Program.objects.get(id=id)
    program_videos = ProgramVideo.objects.filter(program_id=program.id)
    return render(request,'view_video_session.html', {'program_videos': program_videos})

def delete_video_session_get(request,id):
    program_video = ProgramVideo.objects.get(id=id)
    program_video.delete()
    messages.success(request, 'Video Session Deleted Successfully.')
    return redirect(f'/myapp/view_video_session/{program_video.program_id}')

def add_google_session_get(request,id):
    program = Program.objects.get(id=id)
    return render(request,'add_google_session.html',{'program':program})

def add_google_session_post(request,id):
    program = Program.objects.get(id=id)
    if request.method == "POST":
        google_meeting_link = request.POST['google_meet_link']
        start_time = request.POST['start_time']
        end_time = request.POST['end_time']
        date = request.POST['date']
        google_session = ProgramClass.objects.create( google_meet_link=google_meeting_link,
                                                      start_time=start_time, end_time=end_time, date=date,
                                                      program_id=program.id)
        google_session.save()
        messages.success(request, 'Google Session Added Successfully.')
        return redirect(f'/myapp/add_google_session_get/{id}')

def view_google_session(request,id):
    program = Program.objects.get(id=id)
    google_sessions = ProgramClass.objects.filter(program_id=program.id)
    return render(request,'view_google_session.html', {'google_sessions': google_sessions})

def delete_google_session_get(request,id):
    google_session = ProgramClass.objects.get(id=id)
    google_session.delete()
    messages.success(request, 'Google Session Deleted Successfully.')
    return redirect(f'/myapp/view_google_session/{google_session.program_id}')

def review_program_get(request,id):
    print(id)
    program_reviews = ProgramReview.objects.filter(program_id=id)
    return render(request,'review_program.html', {'program_reviews': program_reviews})

def change_password_skill_get(request):
    return render(request,'change_password_skill.html')

def change_password_skill_post(request):
    if request.method == "POST":
        old_password = request.POST['old_password']
        new_password = request.POST['new_password']
        user = request.user
        if not check_password(old_password, user.password):
            messages.error(request, 'Old password is incorrect.')
            return redirect('/myapp/change_password_skill_get/')
        user.set_password(new_password)
        user.save()
        messages.success(request, 'Password changed successfully.')
        return redirect('/myapp/view_login/')



def view_company_profile(request):
    company_profile = CompanyProfile.objects.get(LOGIN_id=request.user.id)
    return render(request,'companyProfile.html', {'company': company_profile})

def edit_company_profile_get(request):
    company_profile = CompanyProfile.objects.get(LOGIN_id=request.user.id)
    return render(request,'edit_company_profile.html', {'company': company_profile})

def edit_company_profile_post(request):
    if request.method == "POST":
        company_profile = CompanyProfile.objects.get(LOGIN_id=request.user.id)
        company_profile.company_name = request.POST['company_name']
        company_profile.address = request.POST['address']
        company_profile.phone = request.POST['phone']
        company_profile.email = request.POST['email']
        if 'photo' in request.FILES:
            company_profile.photo = request.FILES['photo']
        company_profile.save()
        messages.success(request, 'Company Profile Updated Successfully.')
        return redirect('/myapp/view_company_profile')

def add_vacancy_get(request):
    return render(request,'add_vacancy.html')

def add_vacancy_post(request):
    if request.method == "POST":
        title = request.POST['title']
        description = request.POST['description']
        requirements = request.POST['requirements']
        status = request.POST['status']
        company_id = CompanyProfile.objects.get(LOGIN_id=request.user.id).id
        vacancy = Vacancy(title=title, description=description, requirements=requirements,
                          status=status, company_id=company_id)
        vacancy.save()
        messages.success(request, 'Vacancy Added Successfully.')
        return redirect('/myapp/add_vacancy_get/')


def view_vacancy(request):
    company_id = CompanyProfile.objects.get(LOGIN_id=request.user.id).id
    vacancies = Vacancy.objects.filter(company_id=company_id)
    return render(request,'view_vacancy.html', {'vacancies': vacancies})

def edit_vacancy_get(request,id):
    vacancy = Vacancy.objects.get(id=id)
    return render(request,'edit_vacancy.html', {'vacancy': vacancy})

def edit_vacancy_post(request,id):
    if request.method == "POST":
        vacancy = Vacancy.objects.get(id=id)
        vacancy.title = request.POST['title']
        vacancy.description = request.POST['description']
        vacancy.requirements = request.POST['requirements']
        vacancy.status = request.POST['status']
        vacancy.save()
        messages.success(request, 'Vacancy Updated Successfully.')
        return redirect('/myapp/view_vacancy')

def view_applications_company(request,id):
    vacancy = Vacancy.objects.get(id=id)
    applications = Application.objects.filter(vacancy_id=vacancy.id)
    return render(request,'view_applications_company.html', {'applications': applications})

def accept_application(request,id):
    application = Application.objects.get(id=id)
    application.status = 'Accepted'
    application.save()
    messages.success(request, 'Application Accepted Successfully.')
    return redirect('/myapp/view_applications_company')

def reject_application(request,id):
    application = Application.objects.get(id=id)
    application.status = 'Rejected'
    application.save()
    messages.success(request, 'Application Rejected Successfully.')
    return redirect('/myapp/view_applications_company')

def register_user_post(request):
    name = request.POST['name']
    email = request.POST['email']
    address = request.POST['address']
    phone = request.POST['phone']
    photo=request.FILES['photo']
    qualification=request.POST['qualification']
    skills=request.POST['skills']
    gender=request.POST['gender']
    dob_str = request.POST['dob']
    dob = datetime.strptime(dob_str, "%d/%m/%Y").date()
    experience=request.POST['experience']
    username = request.POST['username']
    password = request.POST['password']
    if User.objects.filter(username=username).exists():
        return JsonResponse({'error': 'Username already exists.'})
    user = User.objects.create_user(username=username, password=password)
    user.groups.add(Group.objects.get(name='normaluser'))
    user.save()
    normaluser = NormalUser(full_name=name, email=email, address=address, phone=phone, photo=photo,
                            qualification=qualification, skills=skills, gender=gender,
                            dob=dob, experience=experience, LOGIN_id=user.id)
    normaluser.save()
    return JsonResponse({'success': 'User Registered Successfully.'})

def loginapp(request):
    uname = request.POST['uname']
    upass = request.POST['pwd']
    print(uname, upass, 'jhvghh')

    user = authenticate(request, username=uname, password=upass)
    print(user, 'jhh')

    if user is not None:
        print('sldcn')

        # Normal user login
        if user.groups.filter(name='normaluser').exists():
            login_id = user.id
            user_id = NormalUser.objects.get(LOGIN_id=login_id).id
            response = {
                'message': 'Login Successful.',
                'user_id': user_id,
                'login_id': login_id,
                'user_type': 'normaluser'
            }
            print(response, 'response')
            return JsonResponse(response)



        # Fallback: no recognized group
        return JsonResponse({'message': ''})

    else:
        print('else')
        return JsonResponse({'message': 'Invalid username or password.'})

def user_data_get(request):
    user_id = request.POST['uid']
    user_info = NormalUser.objects.get(id=user_id)
    print(user_info)
    data = {
        'id': user_info.id,
        'name': user_info.full_name,
        'email': user_info.email,
        'photo': str(user_info.photo),  # assuming ImageField or FileField
        # add other fields as needed
    }
    return JsonResponse({'data': data})

def view_user_profile(request):
    user_id = request.POST['uid']
    user_info = NormalUser.objects.get(id=user_id)
    user_profile = {
        'id': user_info.id,
        'name': user_info.full_name,
        'email': user_info.email,
        'address': user_info.address,
        'phone': user_info.phone,
        'photo': str(user_info.photo),
        'qualification': user_info.qualification,
        'skills': user_info.skills,
        'gender': user_info.gender,
        'dob': user_info.dob,
        'experience': user_info.experience,

    }
    return JsonResponse({'user_profile':user_profile})

def edit_user_profile_get(request):
    user_id = request.POST['uid']
    user_info = NormalUser.objects.get(id=user_id)
    user_profile = {
        'id': user_info.id,
        'name': user_info.full_name,
        'email': user_info.email,
        'address': user_info.address,
        'phone': user_info.phone,
        'photo': str(user_info.photo),
        'qualification': user_info.qualification,
        'skills': user_info.skills,
        'gender': user_info.gender,
        'dob': user_info.dob,
        'experience': user_info.experience,
    }
    return JsonResponse({'user_profile':user_profile})

def update_user_profile_post(request):
    user_id = request.POST['uid']
    user_info = NormalUser.objects.get(id=user_id)
    user_info.full_name = request.POST['name']
    user_info.email = request.POST['email']
    user_info.address = request.POST['address']
    user_info.phone = request.POST['phone']
    user_info.qualification = request.POST['qualification']
    user_info.skills = request.POST['skills']
    user_info.gender = request.POST['gender']
    user_info.dob = request.POST['dob']
    user_info.experience = request.POST['experience']
    if 'photo' in request.FILES:
        user_info.photo = request.FILES['photo']
    user_info.save()
    return JsonResponse({'success': 'User Profile Updated Successfully.'})

def change_password_user(request):
    uid = request.POST['uid']
    old_password = request.POST['old_password']
    new_password = request.POST['new_password']

    try:
        valet = NormalUser.objects.get(id=uid)
        user = User.objects.get(id=valet.LOGIN_id)

        if not user.check_password(old_password):
            return JsonResponse({'status': 'error', 'message': 'Old password is incorrect'})

        user.set_password(new_password)
        user.save()
        return JsonResponse({'status': 'success', 'message': 'Password changed successfully'})

    except NormalUser.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Valet not found'})
    except User.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'User not found'})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': f'An error occurred: {str(e)}'})



def get_reviews_user(request):
    reviews = AppReview.objects.filter(NormalUser_id=request.POST['uid'])
    data = [
        {
            "user_name": r.NormalUser.full_name,
            "rating": r.rating,
            "review": r.review,
        } for r in reviews
    ]
    return JsonResponse(data, safe=False)

def add_review_user(request):
    if request.method == "POST":
        user_id = request.POST['uid']
        rating = request.POST['rating']
        review = request.POST['review']

        AppReview.objects.create(
            NormalUser_id=user_id,
            rating=rating,
            review=review
        )
        return JsonResponse({"success": True})

def get_complaints_user(request):
    complaints = Complaint.objects.filter(NormalUser_id=request.POST['uid']).values()
    print(complaints)
    return JsonResponse(list(complaints), safe=False)

def add_complaint_user(request):
    complaint_text = request.POST['complaint_text']
    NormalUser_id = request.POST['uid']
    Complaint.objects.create(
        NormalUser_id=NormalUser_id,
        complaint_text=complaint_text,
        status='pending'
    )

