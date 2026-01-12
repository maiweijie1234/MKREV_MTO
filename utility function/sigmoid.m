% sigmoid函数
function output = sigmoid(x)
    output = 1 ./(1+exp(-x));
end