function angle = calculateAngle( vector, normal )
    angle = ((dot(vector, normal))/(dot(norm(vector), norm(normal))));
end

