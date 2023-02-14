Shader "Toy/ToyShader08"
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

            fixed3 drawCircle(fixed2 uv, float2 center, float radius, fixed3 color)
            {
                // 边缘没有明显锯齿
                return lerp(color, fixed3(1, 1, 1), smoothstep(radius, radius + 0.003, length(uv - center)));
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                float2 st = IN.uv;
                float pct;
                fixed3 color = _Color;
                float2 center = 0.5;

                // 旋转+缩放
                // center += float2(0.2 * sin(_Time.y), 0.2 * cos(_Time.y));
                // color = drawCircle(IN.uv, center, 0.2 * abs(sin(_Time.y)), _Color);

                // pct = length(st - float2(0.4, 0.4)) + length(st - float2(0.6, 0.6));
                // pct = length(st - float2(0.4, 0.4)) * length(st - float2(0.6, 0.6));
                pct = min(length(st - float2(0.4, 0.4)) , length(st - float2(0.6, 0.6)));
                // pct = max(length(st - float2(0.4, 0.4)) , length(st - float2(0.6, 0.6)));
                // pct = pow(length(st - float2(0.4, 0.4)) , length(st - float2(0.6, 0.6)));
                
                color = pct;
                // color = circle(st + 0.25, 0.5);

                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
