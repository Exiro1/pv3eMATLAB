classdef TCPServer
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        
        function convertFile(o, file)
           t = readtable(file)
           s = size(t)
           len = s(2)
           s = s(1)-2
           t = t{:,:}
           for i = 0:s
            fdata(i+1,:) = o.updateData(t(i+1,:),len);
           end
           c = clock()
           writematrix(fdata, "decoded_log_"+c(4) + "_" +c(5) + "_" + ceil(c(6))+".csv")
        end
             
        %transforme un entier signé sur 8,16,24 ou 32 bits en un double
        %signé
        function x = decodeSigned(o,data, index, len, scal, off)
            v = int32(0)
            for i = 0:(len-1)
                v = bitor(v,bitshift(int32(data(index+i)),8*(len-i-1)))
            end
            
            %on verifie que le bit de poid fort est un 1 (indique que la valeur est negative)
            if bitshift(v, -(len*8-1)) == 1
                %exemple avec input = -11317 (sur 16 bit signés) ou 54219 (sur 16 bits non signés et 32 bits signés) (11010011 11001011)
                %on crée un entier egal a -1 (11111111 11111111 11111111 11111111)
                toAdd = int32(-1);
                %on masque la partie utilisé par la valeur de base
                % pour un input codé sur 16 bits : 11111111 11111111 00000000 00000000
                toAdd = toAdd- 2^(len*8) +1
                % on effectue un OU binaire entre les deux variables
                % donne : 11111111 11111111 11010011 11001011 (-11317 sur un int)
                v = bitor(toAdd,v)
                %on transformera ensuite xa en un double
            end
            x = double(v)*scal+off
        end
        
        
        function x = decodeUnsigned(o,data, index, len, scal, off)
            v = 0
            for i = 0:(len-1)
                v = bitor(v, bitshift(int32(data(index+i)),8*(len-i-1)))
            end
            
            x = double(v)*scal+off
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
            result(2) = decodeSigned(obj,data,3,2,0.01,0)
            result(3) = decodeSigned(obj,data,5,2,1,0)
            result(4) = decodeUnsigned(obj,data,7,2,1,0)
            result(5) = decodeUnsigned(obj,data,9,2,0.01,0)
            result(6) = decodeUnsigned(obj,data,11,2,0.01,0)
            
            result(7) = concat(obj,data(13),data(14))
            result(8) = decodeUnsigned(obj,data,15,2,0.01,0)
            result(9) = decodeSigned(obj,data,17,2,0.01,0)
            result(10) = decodeSigned(obj,data,19,2,0.01,0)
            
            result(11) = decodeSigned(obj,data,21,2,0.01,0)
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
            
            result(26) = decodeSigned(obj,data,29,2,0.01,0)
            
            result(27) = decodeSigned(obj,data,31,2,0.01,0)

            result(28) = decodeSigned(obj,data,33,2,0.01,0)
            
            result(29) = decodeSigned(obj,data,35,2,0.01,0)
            
           %ajouter les nouvelles données ici
           %si valeur signée : 
           %result(27) = decodeSigned(obj,obj,data,index_data,taille en octet, facteur, offset)
           %si valeur non signée : 
           %result(27) = decodeUnsigned(obj,concat(obj,data, index_data,taille en octet, facteur, offset)
           %si valeur booléen 
           %result(27) = decodeBool(obj,data(index_data),position_octet) 
           %avec position_octet l'index du bit dans l'octet
            
        end
        
    end
end

