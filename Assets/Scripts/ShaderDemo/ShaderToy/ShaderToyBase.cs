using System;
using UnityEditor;
using UnityEngine;

namespace Demos
{
    [ExecuteAlways]
    [RequireComponent(typeof(MeshRenderer))]
    public class ShaderToyBase : MonoBehaviour
    {
        protected Material material;
        private MeshRenderer meshRenderer;
        [SerializeField] private string shaderPath = "Toy/ToyShader01";

        [Header("Shader Variables")]
        [SerializeField] private Texture2D _mainTex;
        [SerializeField, ColorUsage(true, false)] private Color _Color;

        private int _colorId = Shader.PropertyToID("_Color");
        private string prevShaderPath = "";

        private void OnEnable()
        {
            meshRenderer = this.GetComponent<MeshRenderer>();
            if (material == null)
            {
                material = new Material(Shader.Find(shaderPath));
                meshRenderer.material = material;
                prevShaderPath = shaderPath;
            }

            material.mainTexture = _mainTex;
            material.SetColor(_colorId, _Color);
            SetMatProperties();
        }

        protected virtual void SetMatProperties()
        {

        }

        protected void OnDisable()
        {
            if (material != null)
            {
                DestroyMaterial();
            }
        }

        protected void OnDestroy()
        {
            if (material != null)
            {
                DestroyMaterial();
            }
        }

        public void DestroyMaterial()
        {
#if UNITY_EDITOR
            if (EditorApplication.isPlaying == false)
            {
                DestroyImmediate(material);
                material = null;
                return;
            }
#endif

            Destroy(material);
            material = null;
        }

#if UNITY_EDITOR
        protected void OnValidate()
        {
            if (!isActiveAndEnabled || meshRenderer == null || material == null)
            {
                return;
            }

            if (prevShaderPath != shaderPath)
            {
                Shader shader = Shader.Find(shaderPath);
                if (shader == null)
                    return;
                material = new Material(shader);
                meshRenderer.material = material;
            }

            material.mainTexture = _mainTex;
            material.SetColor(_colorId, _Color);
            SetMatProperties();
        }
#endif
    }
}
