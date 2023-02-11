using UnityEngine;

namespace Demos
{
    public class EdgeDetection : PostEffectsBase
    {
        public Shader briSatConShader;
        private Material briSatConMaterial;
        public Material material
        {
            get
            {
                briSatConMaterial = CheckShaderAndCreateMaterial(briSatConShader, briSatConMaterial);
                return briSatConMaterial;
            }
        }

        [Range(0.0f, 1.0f)]
        public float edgesOnly = 0.0f;
        public Color edgeColor = Color.black;
        public Color backgroundColor = Color.white;

        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (material != null)
            {
                // 向shader传数据
                material.SetFloat("_EdgeOnly", edgesOnly);
                material.SetColor("_EdgeColor", edgeColor);
                material.SetColor("_BackgroundColor", backgroundColor);

                Graphics.Blit(src, dest, material);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
