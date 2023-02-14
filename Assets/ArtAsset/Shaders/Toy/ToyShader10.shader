Shader "Toy/ToyShader10"
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

                // 以(.5, .5)为原点，建立极坐标系
                float2 pos = st - 0.5;
                // a取值范围为[-PI, PI]。而-PI在左边,step(_Time.y, a)时是从-PI位置开始的，所以将整体旋转180度，使得动画从正常的左侧开始。
                pos = mul(rotate2d(PI), pos); 
                float r = length(pos) * 2;
                float a = atan2(pos.y, pos.x) + r;

                float f; // 曲线定义。即\rho
                // f = M * cos(a*(_Time.y));
                f = abs(cos(a*3.));
                // f = abs(cos(a*2.5))*.5+.3;
                // f = abs(cos(a*_Time.y)*sin(a*3.))*.8+.1;
                // f = smoothstep(-.5,1., cos(a*10.))*0.2+0.5;
                // f = 1 + sin(a);
                // f = abs(cos(A*a)*sin(B*a));

                // color = f; // 填充
                color = smoothstep(f-0.01,f,r) * smoothstep(f+0.01,f,r); // 画线

                color *= 1 - step(min(_Time.y, TWO_PI) - PI, a); // 简易画线动画

                // color = a; // 看a的取值范围。 [-PI, PI]

                // color = 1 - smoothstep(f+0.1,f,r);
                // color = lerp(fixed3(1,1,0), _Color, 1 - smoothstep(f+0.1,f,r));

                return fixed4(color, 1.0);
            }

            ENDCG  
        }
    }
    FallBack "Diffuse"
}
