
VAO:顶点数组对象
VBO:顶点缓冲对象
EBO或IBO:索引缓冲对象
顶点属性:渲染	出这个点所需要的全部数据，包括位置 像素值等

图形渲染管线:把输入的3D坐标转化为2D坐标的过程
这个过程大体上可以分为两大步:
	1. 3D坐标转为2D坐标
	2. 2D坐标转为实际有颜色的像素

具体流程为:

	顶点数据输入--->顶点着色器--->图元装配--->几何着色器--->光栅化--->片段着色器--->测试与混合

	每一步的输出作为下一步的输入

其中我们自己可以定义的是:顶点着色器   片段着色器

	顶点着色器:主要把3D坐标转为2D坐标

	图元装配: 将顶点着色器输出的所有顶点装配成指定的形状，如 点 三角形等

	几何着色器 + 光栅化: 将图元映射成为最终屏幕上相应的像素(包含了渲染一个像素所需要的所有数据)，并且会进行裁切，
		把视图以外的像素抛弃

	片段着色器:计算一个像素的最终颜色值

	测试预混合:判断一个像素的深度和透明度，即这个像素在其他物体的前面还是后面

代码解释:
	定义一组顶点数据，发送到顶点着色器，着色器会在GPU上分配内存来储存输入的顶点数据，我们用VBO来管理这个内存

		float vertices[] = {
		-0.5f, -0.5f, 0.0f,
		0.5f, -0.5f, 0.0f,
		0.0f, 0.5f, 0.0f };

	定义一个顶点着色器  包含着顶点属性，不过这里仅用到位置信息，每一个顶点的所有属性是存储在一起的
	const char* vertexShaderSource = "#version 330 core \n"
		"layout(location = 0) in vec3 aPos;\n"
		"void main()\n"
		"{\n"
		"gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
		"}\n\0";

	//由于VAO是对VBO的引用，所以要先创建VAO 然后再创建VBO
	unsigned int VAO, VBO;
	//绑定VOA对象
	glGenVertexArrays(1, &VAO); //产生VAO的数量设为1
	glBindVertexArray(VAO);

	//绑定VBO对象
	glGenBuffers(1, &VBO); //创建VBO   ----------1
	glBindBuffer(GL_ARRAY_BUFFER, VBO); //把新建的VBO缓冲绑定到GL_ARRAY_BUFFER上
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW); //把顶点数据复制到GPU中

	//
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);
	//解除绑定
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	///////////////////////////////编译顶点着色器 (在上面有一个定义好的顶点着色器，下一节来具体解释)
	unsigned int vertexShader = glCreateShader(GL_VERTEX_SHADER); //创建着色器对象
	glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);//把定义好的着色器附加到着色器对象上
	glCompileShader(vertexShader); //编译着色器
	// 检查是否编译成功了(可省略)
	int success;
	char infoLog[512];
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
	}
	///////////////////////////////////片段着色器：原理跟顶点着色器一样
	unsigned int fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(fragmentShader, 1, &fragmentShaderSource, NULL);
	glCompileShader(fragmentShader);
	// check for shader compile errors
	glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
	if (!success)
	{
		glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
	}
	//////////////////////////////////着色器程序..要使用上面定义的着色器则必须把他们不连接到一个着色器程序对象上
	unsigned int shaderProgram = glCreateProgram(); //创建一个程序对象
	glAttachShader(shaderProgram, vertexShader);
	glAttachShader(shaderProgram, fragmentShader);
	glLinkProgram(shaderProgram);
	// 检验是否链接成功
	glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
	if (!success) {
		glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
		std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
	}
	//shader链接到programme后即可断开连接
	glDeleteProgram(vertexShader);
	glDeleteProgram(fragmentShader);


	while (!glfwWindowShouldClose(window))
	{
		processInput(window);//¼àÌýÓÃ»§ÊÇ·ñÊäÈëÊÂ¼þ..
		glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);

		glUseProgram(shaderProgram);
		glBindVertexArray(VAO);
		glDrawArrays(GL_TRIANGLES, 0, 3);

		glfwSwapBuffers(window);
		glfwPollEvents();
	}

	glDeleteVertexArrays(1, &VAO);
	glDeleteBuffers(1, &VBO);

	glfwTerminate();

索引缓冲对象