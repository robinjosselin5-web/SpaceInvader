Memo

Largeur écran = 448
Hauteur écran = 704 

L écran /16 = 28
L écran /32 = 14
L écran /64 = 7

H écran/16 = 44
H écran/64 = 11

for i = 1, colBackground do 
    for a = 1, rawBackground do 
        if a > 0 and a <= 7 then 
            love.graphics.draw(Background.imageTop, imageWidth * i - imageWidth, imageHeight * a - imageHeight) 
        elseif a == 8 then 
            love.graphics.draw(Background.imageTop, imageWidth * i - imageWidth, imageHeight * a - imageHeight) 
            love.graphics.draw(Background.imageMiddle, imageWidth * i - imageWidth, imageHeight * a - imageHeight) 
        else 
            love.graphics.draw(Background.imageBottom, imageWidth * i - imageWidth, imageHeight * a - imageHeight) 

        end 

        end 

        end 

        end