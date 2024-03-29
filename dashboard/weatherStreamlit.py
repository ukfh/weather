import pandas as pd
#import matplotlib.pyplot as plt
import streamlit as st
import plotly.express as px
import numpy as np


# get the data from the github reop
df = pd.read_csv('https://raw.githubusercontent.com/ukfh/weather/main/R/latest_weather.csv'
                 , sep='\t'
                 , lineterminator='\n'
                 , header=None
                 #, names=['dt', 'place', 'metric', 'hour', 'datetime', 'value']
                 )

# the data has no column names we need to add them
df.rename(columns={0: "dt", 1: "place", 2: "metric", 3: "hour", 4: "datetime", 5: "value"}, inplace=True)
#print(df[0])

# turn the date time into a date time
df['datetime'] = pd.to_datetime(df['datetime'])

#print(df.tail())
#df["dt"]

# change from long to wide format, this may not be necessary
df2 = df.pivot(index='datetime', columns=['metric'], values=['value'])
df2['datetime'] = df2.index

# rename the columns
df2.columns = df2.columns.map('_'.join)

#print(df2.head())
#print(df2['value_h'].head())

# select the numeric columns and turn them into numbers
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

# find the start and end time
endTime = str(plotData['datetime_'].max())
startTime = str(plotData['datetime_'].min())
#print(endTime)

title = 'Latest observations for Odiham'
#print(title)
st.title(title, anchor=None)

st.write('This page displays the weather data for the last 7 days in Odiham between ' + startTime + ' and ' + endTime + '.'
         + ' The data is processed using code in  https://github.com/ukfh/weather ')


# the plots

# temperature ######################################################################
st.header('Temperature')
fig = px.line(
    plotData,
    x='datetime_', y='value_t',
    #   size="pop",
    #   color="continent",
    #  hover_name="country",
    #  log_x=True,
    #  size_max=60,
    labels={
                     "datetime_": "Date",
                     "value_t": "C"
                 },
    width=1600, height=400
 )

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
       # Use the Streamlit theme.
       # This is the default. So you can also omit the theme argument.
       st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
       # Use the native Plotly theme.
       st.plotly_chart(fig, theme=None, use_container_width=True)

# Humidity ######################################################################
st.header('Relative Humidity')
fig = px.line(
    plotData,
    x='datetime_', y='value_h',
 #   size="pop",
 #   color="continent",
  #  hover_name="country",
  #  log_x=True,
  #  size_max=60,
    labels={
        "datetime_": "Date",
        "value_h": "%"
    }
)

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
    # Use the Streamlit theme.
    # This is the default. So you can also omit the theme argument.
    st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
    # Use the native Plotly theme.
    st.plotly_chart(fig, theme=None, use_container_width=True)

# Pressure ######################################################################
st.header('Pressure')
fig = px.line(
    plotData,
    x='datetime_', y='value_p',
 #   size="pop",
 #   color="continent",
  #  hover_name="country",
  #  log_x=True,
  #  size_max=60,
    labels={
        "datetime_": "Date",
        "value_p": "mBar"
    }
)

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
    # Use the Streamlit theme.
    # This is the default. So you can also omit the theme argument.
    st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
    # Use the native Plotly theme.
    st.plotly_chart(fig, theme=None, use_container_width=True)

# Visibilty ######################################################################
st.header('Visibility')
fig = px.line(
    plotData,
    x='datetime_', y='value_v',
 #   size="pop",
 #   color="continent",
  #  hover_name="country",
  #  log_x=True,
  #  size_max=60,
    labels={
        "datetime_": "Date",
        "value_v": "m"
    }
)

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
    # Use the Streamlit theme.
    # This is the default. So you can also omit the theme argument.
    st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
    # Use the native Plotly theme.
    st.plotly_chart(fig, theme=None, use_container_width=True)

# wind speed ######################################################################
st.header('Wind speed')
fig = px.line(
    plotData,
    x='datetime_', y='value_w',
 #   size="pop",
 #   color="continent",
  #  hover_name="country",
  #  log_x=True,
  #  size_max=60,
    labels={
        "datetime_": "Date",
        "value_w": "mph"
    }
)

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
    # Use the Streamlit theme.
    # This is the default. So you can also omit the theme argument.
    st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
    # Use the native Plotly theme.
    st.plotly_chart(fig, theme=None, use_container_width=True)

# dew point ######################################################################

st.header('Dew Point')
fig = px.line(
    plotData,
    x='datetime_', y='value_dp',
 #   size="pop",
 #   color="continent",
  #  hover_name="country",
  #  log_x=True,
  #  size_max=60,
    labels={
        "datetime_": "Date",
        "value_dp": "C"
    }
)

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
    # Use the Streamlit theme.
    # This is the default. So you can also omit the theme argument.
    st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
    # Use the native Plotly theme.
    st.plotly_chart(fig, theme=None, use_container_width=True)


# dew point ######################################################################

st.header('Temperature against humidity')
fig = px.scatter(
    plotData,
    x='value_t', y='value_h',
 #   size="pop",
    color="value_p",
    hover_name="datetime_",
  #  log_x=True,
  #  size_max=60,
    labels={
        "datetime_": "Date",
        "value_t": "C",
        "value_h": "Humidity",
        "value_p": "Pressure"
    }
)

tab1, tab2 = st.tabs(["Streamlit theme (default)", "Plotly native theme"])
with tab1:
    # Use the Streamlit theme.
    # This is the default. So you can also omit the theme argument.
    st.plotly_chart(fig, theme="streamlit", use_container_width=True)
with tab2:
    # Use the native Plotly theme.
    st.plotly_chart(fig, theme=None, use_container_width=True)



