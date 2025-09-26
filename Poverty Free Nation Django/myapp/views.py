from django.contrib.auth import authenticate, login
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
                return redirect('/myapp/view_adminhome/', {'message': 'Login successful!'})
            elif user.groups.filter(name='company').exists():
                login(request, user)
                return redirect('/myapp/view_company_home/',{'message': 'Login successful!'})
            elif user.groups.filter(name='skill_center').exists():
                login(request, user)
                return redirect('/myapp/view_skill_center_home/', {'message': 'Login successful!'})

        else:
            return render(request, 'login.html', {'error': 'Invalid username or password.'})

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
        return render(request, 'SkillCenterRegisteration.html', {'message': 'Registration successful!'})