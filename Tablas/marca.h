#ifndef MARCA_H
#define MARCA_H

#include <QWidget>

class QRect;

//********Marca***************//

class Marca : public QWidget
{
public:
    explicit Marca(int tam = 5, QWidget *parent = nullptr);
protected:
    void paintEvent(QPaintEvent *) override;

private:
    int m_tamLado;
};

//********Marco***************//

class Marco : public QWidget
{
public:
    explicit Marco(QWidget *parent = nullptr);
protected:
    void paintEvent(QPaintEvent *) override;
};

#endif // MARCA_H
