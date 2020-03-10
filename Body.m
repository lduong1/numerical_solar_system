classdef Body
    properties
        mass(1,1) double {mustBeNonnegative} %kg
        posi double %m
        velo double %m s^-1
        acce double %m s^-2
    end
    methods
        function obj = Body(m, r, v, a) %Constructor
            obj.mass = m;
            obj.posi = obj.toSpatialVector(r);
            obj.velo = obj.toSpatialVector(v);
            obj.acce = obj.toSpatialVector(a);
        end
        
        function F = grav(obj, other)
            %Returns the gravitational force
            d = obj.posi - other.posi;
            F = -1*6.67E-11*obj.mass*other.mass*d/(norm(d)^3);
        end
        function new = move(obj, dt)
            newVelo = obj.velo + obj.acce * dt;
            newPosi = obj.posi + newVelo * dt;
            new = Body(obj.mass, newPosi, newVelo, obj.acce);
        end
        function d = dist(obj, other)
            %Return the distance between two Bodies
            d = norm(obj.posi - other.posi);
        end
        
        function obj = set.acce(obj, value)
            obj.acce = obj.toSpatialVector(value);
        end
        function obj = set.velo(obj, value)
            obj.velo = obj.toSpatialVector(value);
        end
        function obj = set.posi(obj, value)
            obj.posi = obj.toSpatialVector(value);
        end
    end
    methods (Access = protected)
        function y = toSpatialVector(obj, x)
            % Converts a vector to a 3x1 column vector
            if (min(size(x)) > 1 || length(x) > 3)
                error('Input must be a vector of length at most 3');
            else
                if (iscolumn(x)) y = x;
                else y = x';
                end
            end
            y = [y; zeros(3-length(y),1)];
        end
    end
end