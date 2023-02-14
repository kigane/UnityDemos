Shader "Toy/ToyShader02"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }

    SubShader
    {
        // Tags { "RenderType"="Opaque" }
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        Pass
        {
            // ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed4 _Color;

            struct a2v
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            float plotLine(float2 uv)
            {
                return smoothstep(0.02, 0, abs(uv.x - uv.y));
            }

            float plot(float2 uv, float pct)
            {
                return smoothstep(pct-0.02, pct, uv.y) - smoothstep(pct, pct + 0.02, uv.y);
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                fixed4 fragColor;
                float x = IN.uv.x;

                float y;
                // 定义曲线
                // y = sin((x - 0.25) * 2 * PI); 
                // y = exp(x) - 1; 
                // y = step(0.5, x);
                // y = smoothstep(0.3, 0.6, x);
                y = smoothstep(0.25,0.5,x) - smoothstep(0.5,0.75,x);

                fixed3 color = fixed3(y, y, y);
                float pct;
                // pct = plot(IN.uv);
                pct = plot(IN.uv, y);
                // 灰度表示函数值大小。绿色为曲线。
                fragColor = lerp(fixed4(color, 1), fixed4(0, 1, 0, 1), pct);
                return fragColor;
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
