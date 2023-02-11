// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDemos/12/BrightnessSaturationAndContrast"
{
    Properties { // 可以省略。因为是从脚本获取的值，不需要在材质面板操作。
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Brightness ("Brightness", Float) = 1
        _Saturation("Saturation", Float) = 1
        _Contrast("Contrast", Float) = 1
    }
    SubShader {
        Pass {  
            // 屏幕后处理实际上是在场景中绘制了一个与屏幕同宽同高的四边形面片
            // 为了防止它对其他物体产生影响，我们需要设置相关的渲染状态。
            ZTest Always Cull Off ZWrite Off
            
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
            
            #include "UnityCG.cginc"  
            
            sampler2D _MainTex;  
            half _Brightness;
            half _Saturation;
            half _Contrast;
            
            struct v2f {
                float4 pos : SV_POSITION;
                half2 uv: TEXCOORD0;
            };
            
            v2f vert(appdata_img v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target {
                fixed4 renderTex = tex2D(_MainTex, i.uv);  
                
                // Apply brightness
                fixed3 finalColor = renderTex.rgb * _Brightness;
                
                // Apply saturation
                fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
                fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
                finalColor = lerp(luminanceColor, finalColor, _Saturation);
                
                // Apply contrast
                fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
                finalColor = lerp(avgColor, finalColor, _Contrast);
                
                return fixed4(finalColor, renderTex.a);  
            }  
            
            ENDCG
        }  
    }
    
    Fallback Off
}
