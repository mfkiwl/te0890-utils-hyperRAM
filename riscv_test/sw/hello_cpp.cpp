/*
 * Test program for C++ on RISC-V.
 *
 * This program is designed to be linked with PicoLibC.
 * It runs on a bare-metal RISC-V system, using rvlib to access
 * system peripherals.
 *
 * Written in 2021 by Joris van Rantwijk.
 *
 * To the extent possible under law, the author has dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * See <http://creativecommons.org/publicdomain/zero/1.0/>
 */

#include <cstdio>  // do not use <iostream> it is gigantic
#include <cmath>
#include <vector>

using namespace std;


class Shape {
  public:
    Shape();
    virtual ~Shape();
    virtual float area() const = 0;
};


class Rectangle : public Shape {
  public:
    Rectangle(int length, int width);
    virtual float area() const;
  private:
    int _length, _width;
};


class Circle : public Shape {
  public:
    Circle(int radius);
    virtual float area() const;
  private:
    int _radius;
};


Shape::Shape()
{
    printf("constructing shape at 0x%p\n", this);
}


Shape::~Shape()
{
    printf("destructing shape at 0x%p\n", this);
}


Rectangle::Rectangle(int length, int width)
  : _length(length)
  , _width(width)
{
    printf("constructing %dx%d rectangle\n", _length, _width);
}


float Rectangle::area() const
{
    return _length * _width;
}


Circle::Circle(int radius)
  : _radius(radius)
{
    printf("constructing circle R=%d\n", _radius);
}


float Circle::area() const
{
    return M_PI * _radius * _radius;
}


int main()
{
    printf("RISC-V test with C++\n");

    // Fun with classes.
    Rectangle rect(4, 5);
    printf("area of rectangle = %f\n", rect.area());

    // Try new, delete and std::vector.
    vector<Shape*> shapes;
    shapes.push_back(new Circle(5));
    shapes.push_back(new Rectangle(3, 8));

    for (Shape *shape : shapes) {
        printf("area = %f\n", shape->area());
        // Try RTTI.
        if (dynamic_cast<Circle*>(shape)) {
            printf("(that was a circle)\n");
        }
    }

    for (Shape *shape : shapes) {
        delete shape;
    }
    shapes.clear();

    printf("done\n");

    return 0;
}
