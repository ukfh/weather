import pandas as pd
#import matplotlib.pyplot as plt
import streamlit as st
import numpy as np



df = pd.read_csv('./latest_weather.csv'
                 , sep='\t'
                 , lineterminator='\n'
                 , header=None
                 #, names=['dt', 'place', 'metric', 'hour', 'datetime', 'value']
                 )
df.rename(columns={0: "dt", 1: "place", 2: "metric", 3: "hour", 4: "datetime", 5: "value"}, inplace=True)
#print(df[0])
df['datetime'] = pd.to_datetime(df['datetime'])
#print(df.tail())
#df["dt"]
df2 = df.pivot(index='datetime', columns=['metric'], values=['value'])
df2['datetime'] = df2.index
df2.columns = df2.columns.map('_'.join)
#print(df2.head())
#print(df2['value_h'].head())

plotData = df2[[ "datetime_", 'value_dp', 'value_h', 'value_p' ,'value_t', 'value_v', 'value_w']]
plotData['value_h'] = pd.to_numeric(plotData['value_h'], errors='coerce')
plotData['value_dp'] = pd.to_numeric(plotData['value_dp'], errors='coerce')
plotData['value_p'] = pd.to_numeric(plotData['value_p'], errors='coerce')
plotData['value_t'] = pd.to_numeric(plotData['value_t'], errors='coerce')
plotData['value_v'] = pd.to_numeric(plotData['value_v'], errors='coerce')
plotData['value_w'] = pd.to_numeric(plotData['value_w'], errors='coerce')


#print(plotData.head())
#plotData.plot(kind = 'scatter', x = 'datetime_', y = 'value_h')
#plt.show()

endTime = str(plotData['datetime_'].max())
#print(endTime)
title = 'Latest observations for Odiham ending ' + endTime
#print(title)
st.title(title, anchor=None)
st.text('This displays the weather data for the last 7 days in Odiham.')

st.header('Temperature')
st.line_chart(plotData,  x = 'datetime_', y = 'value_t')

st.header('Humidity')
st.line_chart(plotData,  x = 'datetime_', y = 'value_h')

st.header('Pressure')
st.line_chart(plotData,  x = 'datetime_', y = 'value_p')

st.header('Visibility')
st.line_chart(plotData,  x = 'datetime_', y = 'value_v')

st.header('Wind speed')
st.line_chart(plotData,  x = 'datetime_', y = 'value_w')

st.header('Dew Point')
st.line_chart(plotData,  x = 'datetime_', y = 'value_dp')

