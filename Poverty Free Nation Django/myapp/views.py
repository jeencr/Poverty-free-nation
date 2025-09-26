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
                return redirect('/myapp/view_adminhome', {'message': 'Login successful!'})
            elif user.groups.filter(name='company').exists():
                login(request, user)
                return redirect('/myapp/view_company_home',{'message': 'Login successful!'})
            elif user.groups.filter(name='skill_center').exists():
                login(request, user)
                return redirect('/myapp/view_skill_center_home', {'message': 'Login successful!'})

        else:
            return render(request, 'login.html', {'error': 'Invalid username or password.'})