Shader "Toy/ToyShader04"
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
                return smoothstep(pct-0.02, pct, uv.y) - smoothstep(pct, pct + 0.02, uv.y);
            }

            fixed4 frag(v2f IN) : SV_Target 
            {
                fixed4 fragColor = fixed4(0.149,0.141,0.912, 1);
                fixed3 colorA = _Color;
                fixed3 colorB = 1-_Color;
                float t;
                t = abs(sin(_Time.y));
                // t = smoothstep(0.2, 0.8, IN.uv.x);
                t = cos(PI * 0.5 * (fmod(_Time.y, 2) - 1));

                fragColor = fixed4(lerp(colorA, colorB, t), 1);
                
                return fragColor;
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
