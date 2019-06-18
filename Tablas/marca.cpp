#include "marca.h"
#include <QPainter>
#include <QRect>

//****************Marca*****************/

Marca::Marca(int tam, QWidget *parent) : m_tamLado(tam), QWidget(parent)
{
    setAttribute(Qt::WA_NoSystemBackground);
    setAttribute(Qt::WA_TransparentForMouseEvents);
}

void Marca::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    QPen pen;
    pen.setWidth(m_tamLado);
    pen.setColor(QColor(Qt::black));
    p.setPen(pen);
    p.drawRect(rect().x()+rect().width()-m_tamLado,
               rect().y()+rect().height()-m_tamLado,
               rect().x()+rect().width(),
               rect().y()+rect().height());
}


//****************Marco*****************/

Marco::Marco(QWidget *parent) : QWidget(parent)
{
    setAttribute(Qt::WA_NoSystemBackground);
    setAttribute(Qt::WA_TransparentForMouseEvents);
}

void Marco::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    QPen pen;
    pen.setWidth(4);
    pen.setColor(QColor(Qt::black));
    p.setPen(pen);
    //p.drawRect(rect());
    p.drawLine(rect().topLeft(),rect().bottomLeft());
    p.drawLine(rect().topLeft(),rect().topRight());
    pen.setWidth(1);
    pen.setColor(QColor(Qt::black));
    p.setPen(pen);
    p.drawLine(rect().topRight(),rect().bottomRight());
    p.drawLine(rect().bottomLeft(),rect().bottomRight());
}
