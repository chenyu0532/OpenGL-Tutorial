

初始化glfw--->创建窗口--->初始化glad--->渲染

新知识：绘制不是一下子就绘制完成的，是从左到右，从上到下来绘制的

int main(void)
{
	glfwInit(); //初始化glfw
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3); //使用的主版本号是3
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3); //使用的服版本号是3
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);//使用核心模式
	
	//创建窗口
	GLFWwindow* window = glfwCreateWindow(800, 600, "First Window", NULL, NULL);
	if (window == NULL)
	{
		std::cout << "Fail" << std::endl;
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window); //将创建的窗口设为当前窗口

	//初始化glad,因为glad是用来管理openGL函数指针的
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Glad Fail" << std::endl;
		return -1;
	}
	//告诉openGL下面要渲染的窗口大小，每次改变窗口大小的时候会调用这个函数
	//作用：openGL是根据glViewport中设置的位置、宽、高来进行2D的坐标转换，将openGL中的坐标
	//转换为当前的屏幕坐标，openGL的坐标只能是-1--1，就是讲这个范围内的坐标映射到(0,width)(0,height)中
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

	//用while循环来控制持续的绘制
	while (!glfwWindowShouldClose(window))
	{
		processInput(window);//监听用户是否输入事件..如关闭窗口等

		glClearColor(0.2f, 0.3f, 0.3f, 1.0f);//清理上一次渲染出来的颜色值
		glClear(GL_COLOR_BUFFER_BIT);


		glfwSwapBuffers(window); //这是渲染指令，储存了glfw中所有的像素颜色值，用来绘制的
		glfwPollEvents(); //判断是否有事件，如键盘事件鼠标移动等..
	}
	//释放资源
	glfwTerminate();

	return 0;
}
void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
	glViewport(0, 0, width, height);  //分别是左下角位置和宽度高度
}
void processInput(GLFWwindow* window)
{
	if (glfwGetKey(window, GLFW_KEY_ESCAPE))
	{
		glfwSetWindowShouldClose(window, true);
	}
}
```