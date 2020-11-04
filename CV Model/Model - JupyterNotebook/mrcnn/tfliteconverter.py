import tensorflow as tf

# Convert the model.
converter = tf.lite.TFLiteConverter.from_saved_model('model.py')
tflite_model = converter.convert()
open("trash_ai.tflite", "wb").write(tflite_model)