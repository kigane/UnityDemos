// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDemos/12/EdgeDetect"
{
    Properties { // 可以省略。因为是从脚本获取的值，不需要在材质面板操作。
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _EdgeOnly ("Edge Only", Float) = 1
        _EdgeColor("Edge Color", Color) = (0, 0, 0, 1)
        _BackgroundColor("Background Color", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Pass {  
            // 屏幕后处理实际上是在场景中绘制了一个与屏幕同宽同高的四边形面片
            // 为了防止它对其他物体产生影响，我们需要设置相关的渲染状态。
            ZTest Always Cull Off ZWrite Off
            
            CGPROGRAM
            
            #include "UnityCG.cginc"
            
            #pragma vertex vert  
            #pragma fragment fragSobel
            
            sampler2D _MainTex;  
            // 纹理的每个纹素的大小。一张512×512大小的纹理，该值大约为0.001953（即1/512）
            uniform half4 _MainTex_TexelSize;
            fixed _EdgeOnly;
            fixed4 _EdgeColor;
            fixed4 _BackgroundColor;
            
            struct v2f {
                float4 pos : SV_POSITION;
                half2 uv[9] : TEXCOORD0;
            };
            
            v2f vert(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                half2 uv = v.texcoord; 
                // 在顶点着色器中计算需要的9个邻域纹理坐标，节省计算。
                // 这里坐标是不是反了?unity的纹理坐标是以左下角为原点的。
                // 因为计算的梯度所以不影响结果
                o.uv[0] = uv + _MainTex_TexelSize.xy * half2(-1, -1);
                o.uv[1] = uv + _MainTex_TexelSize.xy * half2(0, -1);
                o.uv[2] = uv + _MainTex_TexelSize.xy * half2(1, -1);
                o.uv[3] = uv + _MainTex_TexelSize.xy * half2(-1, 0);
                o.uv[4] = uv + _MainTex_TexelSize.xy * half2(0, 0);
                o.uv[5] = uv + _MainTex_TexelSize.xy * half2(1, 0);
                o.uv[6] = uv + _MainTex_TexelSize.xy * half2(-1, 1);
                o.uv[7] = uv + _MainTex_TexelSize.xy * half2(0, 1);
                o.uv[8] = uv + _MainTex_TexelSize.xy * half2(1, 1);
                
                return o;
            }
            
            fixed luminance(fixed4 color) {
                return  0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b; 
            }
            
            half Sobel(v2f i) {
                const half Gx[9] = {-1,  0,  1,
                    -2,  0,  2,
                -1,  0,  1};
                const half Gy[9] = {-1, -2, -1,
                    0,  0,  0,
                1,  2,  1};		
                
                half texColor;
                half edgeX = 0;
                half edgeY = 0;
                for (int it = 0; it < 9; it++) {
                    texColor = luminance(tex2D(_MainTex, i.uv[it]));
                    edgeX += texColor * Gx[it];
                    edgeY += texColor * Gy[it];
                }
                
                // 用|a|+|b|近似梯度sqrt(a^2+b^2)。梯度越大越可能是边缘。颜色越黑。
                half edge = 1 - abs(edgeX) - abs(edgeY); 
                
                return edge;
            }
            
            fixed4 fragSobel(v2f i) : SV_Target {
                half edge = Sobel(i);
                
                fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[4]), edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
                return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
            }
            
            ENDCG
        } 
    }
    
    Fallback Off
}
