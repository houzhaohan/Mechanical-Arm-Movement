% 机械臂运动仿真

% 机械臂参数
L1 = 500; % 第一段连杆长度
L2 = 500; % 第二段连杆长度

% 机械臂起点和终点
start_point = [300, 0];
end_point = [-300, 0];

% 运动总时间
total_time = 10; % seconds

% 运动的时间向量
t = linspace(0, total_time, 100); % 100个时间点

% 利用三次多项式规划完成点位运动
x_trajectory = linspace(start_point(1), end_point(1), numel(t));
y_trajectory = linspace(start_point(2), end_point(2), numel(t));

% 计算机械臂的角度
if y_trajectory == 0
    theta1 = acos(x_trajectory ./ L1); % 使用反余弦函数计算角度
else
    theta1 = atan2(y_trajectory, x_trajectory); % 正常计算角度
end

% 计算余弦定理中的参数 D
D = (x_trajectory.^2 + y_trajectory.^2 - L1^2 - L2^2) ./ (2 * L1 * L2);

% 计算第二个关节角度
theta2 = atan2(-sqrt(1 - D.^2), D) - atan2(sqrt(1 - D.^2), D);

% 将角度限制在合适的范围内（例如 -π 到 π）
theta1 = wrapToPi(theta1);
theta2 = wrapToPi(theta2);

    

% 绘制机械臂运动仿真动画
figure;
for i = 1:numel(t)
    % 机械臂位置
    x1 = 0;
    y1 = 0;
    x2 = L1 * cos(theta1(i));
    y2 = L1 * sin(theta1(i));

 
    % 绘制机械臂
    plot([x1, x2], [y1, y2], 'b-', 'LineWidth', 2); % 第一段连杆
    hold on;
    plot([x2, x_trajectory(i)], [y2, y_trajectory(i)], 'r-', 'LineWidth', 2); % 第二段连杆
    hold on;
    
    % 绘制连杆起点和终点
    plot(x1, y1, 'ko', 'MarkerSize', 8, 'LineWidth', 2); % 第一段连杆起点
    hold on;
    plot(x2, y2, 'ko', 'MarkerSize', 8, 'LineWidth', 2); % 第一段连杆终点
    hold on;
    
    % 绘制机械臂末端
    plot(x_trajectory(i), y_trajectory(i), 'go', 'MarkerSize', 10, 'LineWidth', 2); % 末端
    hold on;
    axis equal; %将 X 轴和 Y 轴上的刻度范围设置成相同的大小

    axis([-800 800 -500 500]);
    xlabel('X轴');
    ylabel('Y轴');
    title('机械臂动画');
    % 控制动画速度
    pause(0.01);
    if t < num_points
    % 清除绘图
        clf;
    end
end



