Shader "Toy/ToyShader03"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Magnitude("Magnitude", float) = 0
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
            #define PI 3.14159265359

            sampler2D _MainTex;
            fixed4 _Color;
            float _Magnitude;

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

            float plot(float2 uv, float pct)
            {
                return smoothstep(pct-0.05, pct, uv.y) - smoothstep(pct, pct + 0.05, uv.y);
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                fixed4 fragColor;
                fixed3 color = _Color;
                float x = IN.uv.x;

                float y;
                float pct;
                // 定义曲线
                // y = sin((x - frac(_Time.y)) * 2 * PI); 
                // y = exp(x) - 1; 
                // y = step(0.5, x);
                // y = smoothstep(0.3, 0.6, x);
                // y = smoothstep(0.2,0.5,x) - smoothstep(0.5,0.8,x);
                // y = abs(sin(x * 8 * PI)); 
                x = (x - 0.5) * 2;

                y = (1 - pow(abs(x), 2) )* 0.6;
                pct = plot(IN.uv, y);
                fragColor = lerp(fixed4(color, 1), fixed4(0, 1, 0, 1), pct);

                y = (1 - pow(abs(x), 2) ) * 0.6 + 0.05;
                pct = plot(IN.uv, y);
                fragColor = lerp(fragColor, fixed4(1, 0, 0, 1), pct);
                
                y = (1 - pow(abs(x), 2) ) * 0.6 + 0.1;
                pct = plot(IN.uv, y);
                fragColor = lerp(fragColor, fixed4(1, 1, 0, 1), pct);

                return fragColor ;
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
