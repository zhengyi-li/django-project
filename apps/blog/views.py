from django.http import HttpRequest, HttpResponse
from django.shortcuts import render

POSTS = [
    {
        "author": "test author 1",
        "title": "Blog Post 1",
        "content": "First post content",
        "date_posted": "August 27, 2021",
    },
    {
        "author": "test author 2",
        "title": "Blog Post 2",
        "content": "Second post content",
        "date_posted": "August 28, 2021",
    },
]


def home(request: HttpRequest) -> HttpResponse:
    """
    Home view.
    :param request: http request
    :return: http response.
    """
    context = {
        "posts": POSTS,
        "title": "Home",
    }
    return render(request, "blog/home.html", context)


def about(request: HttpRequest) -> HttpResponse:
    """
    About view.
    :param request: request
    :return: http response.
    """
    context = {
        "title": "About",
    }
    return render(request, "blog/about.html", context)
