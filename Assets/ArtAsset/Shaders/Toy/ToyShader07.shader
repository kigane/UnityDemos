Shader "Toy/ToyShader07"
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
            #include "../Helpers.cginc"

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

            // 画出四周的黑边，留出矩形
            fixed3 drawRect(fixed2 uv, float borderLength)
            {
                fixed3 color;
                float2 left_bottom = step(borderLength, uv);
                color = left_bottom.x * left_bottom.y;

                float2 top_right = step(borderLength, 1 - uv);
                color *= top_right.x * top_right.y;
                return color;
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                fixed3 color = _Color;
                float len = 0.022;
                color *= drawHorizontalLine(IN.uv, 0.1, len, 0.3);
                color *= drawHorizontalLine(IN.uv, 0.65, len);
                color *= drawHorizontalLine(IN.uv, 0.85, len);
                color *= drawVerticalLine(IN.uv, 0.05, len, 0.65);
                color *= drawVerticalLine(IN.uv, 0.3, len);
                color *= drawVerticalLine(IN.uv, 0.7, len);
                color *= drawVerticalLine(IN.uv, 0.95, len);
                color *= lerp(_Color, RGB255(199,32,33), (1 - step(0.3, IN.uv.x)) * step(0.65, IN.uv.y));
                color *= lerp(_Color, RGB255(250,193,42), step(0.95, IN.uv.x) * step(0.65, IN.uv.y));
                color *= lerp(_Color, RGB255(2,96,157), step(0.7, IN.uv.x) * (1 - step(0.1, IN.uv.y)));
                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
