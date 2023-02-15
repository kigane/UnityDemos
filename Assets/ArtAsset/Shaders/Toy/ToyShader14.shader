Shader "Toy/ToyShader14"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Magnitude("Magnitude", float) = 0
        _Factora("A", float) = 0
        _Factorb("B", float) = 0
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
            float _Factora;
            float _Factorb;

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

            fixed4 frag(v2f IN) : SV_Target 
            {
                float2 st = IN.uv;
                fixed3 color = _Color;
                float M = _Magnitude; 
                float A = _Factora;
                float B = _Factorb;

                // remap to [-1,1]
                float theta = _Time.y;
                float radius = 0.3;
                float2 pos = remap(0, 1, st, -1, 1); 
                float r = length(pos);
                r = step(r, radius);
                float2 p = radius * float2(cos(theta), -sin(theta));
                float l = length( pos - p*clamp( dot(pos,p)/dot(p,p), 0.0, 1.0) );
                color = lineSegmentSdf(pos, float2(0, 0), float2(cos(_Time.y), sin(_Time.y)), st.y * 0.05);
                color = smoothstep(0.005, 0, color);
                color *= lerp(fixed3(0, 1, 0), fixed3(1, 0, 1), 1 - length(pos));

                // st = float2(atan2(pos.x, pos.y) / TWO_PI + 0.5, length(pos));
                // color = smoothstep(0.051, 0.058, st.y);
                // color *= smoothstep(0.02, 0, frac(st.x + _Time.y/3));

                // color = movingRing(IN.uv, 0.1, 0.05, 1.2);
                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
