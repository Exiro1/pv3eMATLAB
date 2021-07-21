classdef TCPServer
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        
        %transforme un entier signé sur 8,16,24 ou 32 bits en un double
        %signé
        function x = decodeSigned(o,input, len, scal, off)
            xa = double(input)
            %on verifie que le bit de poid fort est un 1 (indique que la valeur est negative)
            if bitshift(input, -(len*8-1)) == 1
                %exemple avec input = -11317 (sur 16 bit signés) ou 54219 (sur 16 bits non signés et 32 bits signés) (11010011 11001011)
                %on crée un entier egal a -1 (11111111 11111111 11111111 11111111)
                toAdd = int32(-1);
                %on masque la partie utilisé par la valeur de base
                % pour un input codé sur 16 bits : 11111111 11111111 00000000 00000000
                toAdd = toAdd- 2^(len*8) +1
                % on effectue un OU binaire entre les deux variables
                % donne : 11111111 11111111 11010011 11001011 (-11317 sur un int)
                xa = bitor(toAdd,input)
                %on transformera ensuite xa en un double
            end
            x = double(xa)*scal+off
        end
        
        function x = decodeUnsigned(o,input, scal, off)
            x = double(input)*scal+off
        end
        
        function x = concat(o,a,b)
            x = bitor(bitshift(int32(a),8),int32(b))
        end
        
        function x = decodeBool(o,b,i)
            x = bitand(bitshift(b,-i),1) == 1
        end
        
        function result = updateData(obj,data, SIZE)
            result = zeros(SIZE,1);
            result(1) = concat(obj,data(1),data(2))
            result(2) = decodeSigned(obj,concat(obj,data(3),data(4)),2,0.01,0)
            result(3) = decodeSigned(obj,concat(obj,data(5),data(6)),2,1,0)
            result(4) = decodeUnsigned(obj,concat(obj,data(7),data(8)),1,0)
            result(5) = decodeUnsigned(obj,concat(obj,data(9),data(10)),0.01,0)
            result(6) = decodeUnsigned(obj,concat(obj,data(11),data(12)),0.01,0)
            
            result(7) = concat(obj,data(13),data(14))
            result(8) = decodeUnsigned(obj,concat(obj,data(15),data(16)),0.01,0)
            result(9) = decodeSigned(obj,concat(obj,data(17),data(18)),2,1,0)
            result(10) = decodeSigned(obj,concat(obj,data(19),data(20)),2,0.01,0)
            
            
            result(11) = decodeSigned(obj,concat(obj,data(21),data(22)),2,0.01,0)
            result(12) = concat(obj,data(23),data(24))
            
            result(13) = decodeBool(obj,data(25),0)
            result(14) = decodeBool(obj,data(25),1)
            result(15) = decodeBool(obj,data(25),2)
            result(16) = decodeBool(obj,data(25),3)
            result(17) = decodeBool(obj,data(25),4)
            result(18) = decodeBool(obj,data(25),5)
            result(19) = decodeBool(obj,data(25),6)
            result(20) = decodeBool(obj,data(25),7)
            
            result(21) = decodeBool(obj,data(26),0)
            result(22) = decodeBool(obj,data(26),1)
            result(23) = decodeBool(obj,data(26),2)
            
            result(24) = data(27)
            result(25) = data(28)
            
            
        end
        
    end
end

