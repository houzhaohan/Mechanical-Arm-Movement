% 机械臂参数
l1 = 500; % 第一个连杆长度
l2 = 500; % 第二个连杆长度

% 起点和终点坐标
start_point = [300, 0];
end_point = [-300, 0];

% 运动时间
total_time = 10; % 单位：秒
num_points = 100; % 时间间隔数

% 初始化位置和角度数组
x_positions = zeros(1, num_points);
y_positions = zeros(1, num_points);
theta1_values = zeros(1, num_points);
theta2_values = zeros(1, num_points);

% 计算每个时间间隔的位置和角度
for t = 1:num_points
    % 计算当前时间对应的比例因子
    t_ratio = t / num_points;
    
    % 插值计算当前时间点的位置
    current_point = start_point + t_ratio * (end_point - start_point);
    x_positions(t) = current_point(1);
    y_positions(t) = current_point(2);
    
    % 根据当前位置计算逆解
    x = current_point(1);
    y = current_point(2);
    

 
        % 计算 theta2  %c2表示余弦值，s2表示正弦值
        c2 = (x^2 + y^2 - l1^2 - l2^2) / (2 * l1 * l2);
        s2 = sqrt(1 - c2^2);
        theta2 = atan2(s2, c2);%atan2将正弦和余弦的比值作为输入，返回对应的角度值。

        % 计算 theta1
        k1 = l1 + l2 * c2;
        k2 = l2 * s2;
        theta1 = atan2(y, x) - atan2(k2, k1);      
 

        theta1_values(t) = theta1;
        theta2_values(t) = theta2;
   
end

% 绘制机械臂位置动画
figure;
hold on;
for t = 1:num_points

     % 奇点检测
    if abs(x) < 50 && abs(y) < 50
        % 如果末端位置接近原点，则避免奇点
        x1 = 0;
        y1 = -500;
        x2 = 0;
        y2 = 0;

    else

    % 计算当前连杆末端位置
    x1 = l1 * cos(theta1_values(t));
    y1 = l1 * sin(theta1_values(t));
    x2 = x_positions(t) - x1;
    y2 = y_positions(t) - y1;

    end
    
    % 绘制机械臂
    plot([0, x1, x_positions(t)], [0, y1, y_positions(t)], 'b', 'LineWidth', 2); % 第一连杆
    hold on;
    plot([x1, x2 + x1], [y1, y2 + y1], 'r', 'LineWidth', 2); % 第二连杆
    hold on;
    
    % 绘制关节位置
    plot(x1, y1, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); % 第一个关节
    hold on;
    plot(x_positions(t), y_positions(t), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % 第二个关节
    
    axis equal; %将 X 轴和 Y 轴上的刻度范围设置成相同的大小
    axis([-800 800 -500 500]);
    xlabel('X轴');
    ylabel('Y轴');
    title('机械臂动画');
    
    pause(total_time / num_points); % 暂停显示
    if t < num_points
        clf; % 清除上一帧的图形
    end
end

% 绘制关节角度、角速度等变化曲线图
figure;
subplot(2,1,1);
plot(1:num_points, theta1_values, 'b', 'LineWidth', 1.5);
hold on;
plot(1:num_points, theta2_values, 'r', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Joint Angle (rad)');
legend('\theta_1', '\theta_2');
title('Joint Angle Variation');

% 计算关节角速度
theta1_velocities = diff(theta1_values) / (total_time / num_points);
theta2_velocities = diff(theta2_values) / (total_time / num_points);

% 绘制关节角速度曲线图
subplot(2,1,2);
plot(1:num_points-1, theta1_velocities, 'b', 'LineWidth', 1.5);
hold on;
plot(1:num_points-1, theta2_velocities, 'r', 'LineWidth', 1.5);
xlabel('Time');
ylabel('Joint Velocity (rad/s)');
legend('\omega_1', '\omega_2');
title('Joint Velocity Variation');
