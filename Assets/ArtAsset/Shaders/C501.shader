Shader  "ShaderDemos/0/Simple Shader"  {
    // 材质提供给我们一个可以方便地调节Unity Shader中参数的方式，通过这些参数，我们可以随时调整材质的效果。
    // 而这些参数就需要写在Properties语义块中。
    Properties {
        _Color("Color tint", Color) = (1.0, 1.0, 1.0, 1.0)
    }

    SubShader  {
        Pass  {
            CGPROGRAM
            // 指定顶点/片元着色器使用的函数名
            #pragma  vertex  vert
            #pragma  fragment  frag

            // POSITION,NORMAL,SV_POSITION称为语义(semantics)，不可省略
            // 语义对应的数据来源于使用该材质的MeshRender组件
            // 使用一个结构体来定义顶点着色器的输入
            struct  a2v  {
                // POSITION语义告诉Unity，用模型空间的顶点坐标填充vertex变量
                float4  vertex  :  POSITION;
                // NORMAL语义告诉Unity，用模型空间的法线方向填充normal变量
                float3  normal  :  NORMAL;
                // TEXCOORD0语义告诉Unity，用模型的第一套纹理坐标填充texcoord变量
                float4  texcoord  :  TEXCOORD0;
            };

            // 使用一个结构体来定义顶点着色器的输出
            struct  v2f  {
                // SV_POSITION语义告诉Unity, pos里包含了顶点在裁剪空间中的位置信息
                float4  pos  :  SV_POSITION;
                // COLOR0语义可以用于存储颜色信息
                fixed3  color  :  COLOR0;
            };

            v2f vert(a2v v) {
                // 声明输出结构
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // v.normal包含了顶点的法线方向，其分量范围在[-1.0, 1.0]
                // 下面的代码把分量范围映射到了[0.0, 1.0]
                // 存储到o.color中传递给片元着色器
                o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }

            // 在CG代码中，我们需要定义一个与属性名称和类型都匹配的变量
            fixed4  _Color;

            // SV_Target也是HLSL中的一个系统语义，它等同于告诉渲染器，把用户的输出颜色存储到一个渲染目标(render target)中，这里将输出到默认的帧缓存中
            fixed4  frag(v2f  i)  :  SV_Target  {
                fixed3  c  =  i.color;
                c *= _Color.rgb;
                // 将插值后的i.color显示到屏幕上
                return  fixed4(c,  1.0);
            }

            ENDCG
        }
    }
}
