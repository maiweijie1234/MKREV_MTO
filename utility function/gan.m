function [gen_modle,dis_modle]=gan(data,D)
%------------
d=vec2mat([data.rnvec],D); %D=300,D=100,D=500
train_x=d(1:40,:);%%2-objective LSMOPs is 30, and 3-objective LSMOPs is 40
[m,~]= size(train_x);
%-----------
generator=nnsetup([D,10,D]);
discriminator=nnsetup([D,10,1]);
%----------
batch_size= m; 
iteration= 60;
%batch_num= floor(m / batch_size); 
start_rate= 0.001;end_rate= 0.6;
%learning_rate= 0.01;
gama=0.95;

for i = 1: iteration
    %learning_rate= learning_rate+0.0067;
    if i<=40  
        %learning_rate= learning_rate+0.01;
        learning_rate= start_rate+(end_rate-start_rate)*(i/40);
    else
        learning_rate=learning_rate*gama^(i-40);
    end
    %kk = randperm(images_num);
    %
    images_real = train_x;
    noise = unifrnd(0,1,m,D);  
    %noise=initializeGaussian(150,300,1);
    
    %前向传播
    generator = nnff(generator, noise); 
    images_fake = generator.layers{generator.layers_count}.a; 
    discriminator = nnff(discriminator,images_fake);
    logits_fake = discriminator.layers{discriminator.layers_count}.z; 
    %%%反向传播
    discriminator = nnbp_d(discriminator, logits_fake, ones(batch_size, 1));
    generator = nnbp_g(generator, discriminator); 
    generator = nnapplygrade(generator, learning_rate);  %优化器，参数更新
    
    %-------- 
    generator = nnff(generator, noise);
    images_fake = generator.layers{generator.layers_count}.a;   % %images_fake就是生成器生成的fake数据，即生成器最后一层的输出,过了sigmoid.
    images = [images_fake; images_real]; 
    discriminator = nnff(discriminator, images); 
    logits = discriminator.layers{discriminator.layers_count}.z;
    labels = [zeros(batch_size,1); ones(batch_size,1)];
    discriminator = nnbp_d(discriminator, logits, labels);
    discriminator = nnapplygrade(discriminator, learning_rate);
    gen_modle=generator;
    dis_modle=discriminator;
    %----
%     g_loss(i) = sigmoid_cross_entropy(logits(1:batch_size), ones(batch_size,1));
%     d_loss (i)= sigmoid_cross_entropy(logits, labels);
%     loss(i,:)=[g_loss(i),d_loss(i)];
%     disp(loss(i,:));
%     if corr2(images_fake,images_real)>0.6  
%         break;
%     end
  
end
end

% sigmoid
function output = sigmoid(x)
    output = 1 ./(1+exp(-x));
end
 
%relu
function output = relu(x)  
    output = max(x,0);
end
 
function output = delta_relu(x)
    output = max(x,0);
    output(output>0) = 1;
end
 
function result = sigmoid_cross_entropy(logits,labels)
    result = max(logits,0) - logits .* labels + log(1+exp(-abs(logits)));
    result = mean(result);
end
 
function result = delta_sigmoid_cross_entropy(logits,labels)
    temp1 = max(logits, 0);
    temp1(temp1>0) = 1;
    temp2 = logits;
    temp2(temp2>0) = -1;
    temp2(temp2<0) = 1;
    result = temp1- labels +exp(-abs(logits))./(1+exp(-abs(logits))) .*temp2;
end
 
function nn = nnsetup(architecture)
    nn.architecture = architecture;
    nn.layers_count = numel(nn.architecture);
    %adam
    nn.t=0;
    nn.beta1 = 0.5;
    nn.beta2 = 0.999; 
    nn.epsilon = 10^(-8); 
    %----------------------
    for i=2 : nn.layers_count
      
        nn.layers{i}.w = normrnd(0, 0.02, nn.architecture(i-1), nn.architecture(i));
        nn.layers{i}.b = normrnd(0, 0.02, 1, nn.architecture(i));
        nn.layers{i}.w_m = 0;
        nn.layers{i}.w_v = 0;
        nn.layers{i}.b_m = 0;
        nn.layers{i}.b_v = 0;
    end
end
 
function nn = nnff(nn, x)
    nn.layers{1}.a = x;  
    for i = 2 : nn.layers_count
        input = nn.layers{i-1}.a;
        w = nn.layers{i}.w;
        b = nn.layers{i}.b;
        nn.layers{i}.z = input *w + repmat(b, size(input,1), 1); 
        if i ~= nn.layers_count
            nn.layers{i}.a = relu(nn.layers{i}.z); 
        else
            nn.layers{i}.a = sigmoid(nn.layers{i}.z);
        end
    end
 
end
 
function nn = nnbp_d(nn, y_h, y)
    n = nn.layers_count;
    nn.layers{n}.d = delta_sigmoid_cross_entropy(y_h, y); 
    for i = n-1 : -1:2 
        d = nn.layers{i+1}.d;
        w = nn.layers{i+1}.w;
        z = nn.layers{i}.z;      
        nn.layers{i}.d = d * w' .* delta_relu(z);
    end
    
    for i = 2: n
        d = nn.layers{i}.d;
        a = nn.layers{i-1}.a;
        %dw
        nn.layers{i}.dw = a'*d /size(d,1);
        %db
        nn.layers{i}.db = mean(d,1); 
    end
end
 
% function g_net = nnbp_g(g_net, d_net)
%     n= g_net.layers_count;
%     a= g_net.layers{n}.a; 
%     g_net.layers{n}.d = d_net.layers{2}.d * d_net.layers{2}.w' .* (a .* (1-a));
%     for i = n-1 : n-2 
%         d = g_net.layers{i+1}.d;
%         w = g_net.layers{i+1}.w;
%         z = g_net.layers{i}.z;      
%         g_net.layers{i}.d = d*w' .* delta_relu(z);
%     end
%     for i= 2:n
%         d = g_net.layers{i}.d;
%         a = g_net.layers{i-1}.a;
%         g_net.layers{i}.dw = a'*d /size(d,1);
%         g_net.layers{i}.db = mean(d,1);
%     end    
% end
% generator的bp
function g_net = nnbp_g(g_net, d_net)
    n = g_net.layers_count;
    a = g_net.layers{n}.a;
    g_net.layers{n}.d = d_net.layers{2}.d * d_net.layers{2}.w' .* (a .* (1-a)); 
    for i = n-1:-1:2
        d = g_net.layers{i+1}.d;
        w = g_net.layers{i+1}.w;
        z = g_net.layers{i}.z;
        g_net.layers{i}.d = d*w' .* delta_relu(z);    
    end

    for i = 2:n
        d = g_net.layers{i}.d;
        a = g_net.layers{i-1}.a;
        g_net.layers{i}.dw = a'*d / size(d, 1);
        g_net.layers{i}.db = mean(d, 1);
    end
end
  
%Adam
function nn = nnapplygrade(nn, learning_rate);
    n = nn.layers_count;
    nn.t = nn.t+1;
    beta1 = nn.beta1;
    beta2 = nn.beta2;
    lr = learning_rate * sqrt(1-nn.beta2^nn.t) / (1-nn.beta1^nn.t);
    for i = 2:n  
        dw = nn.layers{i}.dw;
        db = nn.layers{i}.db;
        nn.layers{i}.w_m = beta1 * nn.layers{i}.w_m + (1-beta1) * dw;
        nn.layers{i}.w_v = beta2 * nn.layers{i}.w_v + (1-beta2) * (dw.*dw);
        nn.layers{i}.w = nn.layers{i}.w -lr * nn.layers{i}.w_m ./ (sqrt(nn.layers{i}.w_v) + nn.epsilon);
        nn.layers{i}.b_m = beta1 * nn.layers{i}.b_m + (1-beta1) * db;
        nn.layers{i}.b_v = beta2 * nn.layers{i}.b_v + (1-beta2) * (db .* db);
        nn.layers{i}.b = nn.layers{i}.b -lr * nn.layers{i}.b_m ./ (sqrt(nn.layers{i}.b_v) + nn.epsilon);        
    end
    
end
  
%%initialization
function noise=initializeGaussian(n,m,sigma)
if nargin < 3
    sigma=0.05;
end

%noise=randn(parameterSize,'double') .* sigma;
noise=randn(n,m) .* sigma;
end