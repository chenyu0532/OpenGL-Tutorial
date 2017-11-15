着色器使用着色器程序语言编写(GLSL)


#version version_number
in type in_variable_name;   输入的变量名及类型
in type in_variable_name;	输入的变量名及类型

out type out_variable_name;	输出的变量名及类型

uniform type uniform_name;  

int main()
{
  // 处理输入并进行一些图形操作
  ...
  // 输出处理过的结果到输出变量
  out_variable_name = weird_stuff_we_processed;
}

一.解释 in out用到的地方
   openGL允许我们在顶点着色器和片段着色器中定义需要的东西
   顶点着色器的输入是顶点属性，输出是作为了片段着色器的输入，片段着色器的输出对应了最终的输出
   const char* vertexShaderSource = 
    "#version 330 core \n"
	"layout(location = 0) in vec3 aPos;\n"   顶点着色器的输入，这里是一个aPos坐标，根据布局，从0开始取
	"out vec4 vertexColor;\n"    输出一个vec4(带颜色值)的值
	"void main()\n"
	"{\n"
	"gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
	"vertexColor = vec4(0.5f, 0.0f, 0.0f, 1.0f);\n"   给输出的变量赋值
	"}\n\0";
	const char *fragmentShaderSource = "#version 330 core\n"
	"in vec4 vertexColor;\n"  片段着色器的输入
	"out vec4 FragColor;\n"   片段着色器的输出
	"void main()\n"
	"{\n"
	"   FragColor = vertexColor;\n"  输出的值是顶点着色器的输出，通过这样，可以改变输出的结果的颜色
	"}\n\0"   

二.uniform