// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "ShaderDemos/1/Diffuse Shader Vertex" {
    Properties {
        _Diffuse("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }

    SubShader {
        pass {
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "lighting.cginc"
            fixed4 _Diffuse;

            struct  a2v  {
                float4  vertex  :  POSITION;
                float3  normal  :  NORMAL;
            };

            struct  v2f  {
                float4  pos  :  SV_POSITION;
                fixed3  color  :  COLOR;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // v.normal 是模型空间向量，需要转到世界空间。这样和光线方向的点积才有意义
                // 模型空间到世界空间的变换矩阵的逆矩阵unity_WorldToObject(4x4)
                // ObjToWorld(3x3) dot v.norml == v.normal^T dot WorldToObj
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                // 光源方向为世界空间向量
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                
                // 计算漫反射
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                return fixed4(i.color, 1.0);
            }

            ENDCG
        }
    }

    FallBack "Diffuse"
}